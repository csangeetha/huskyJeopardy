defmodule JeopardyWeb.GameController do
  use JeopardyWeb, :controller

  alias Jeopardy.Games
  alias Jeopardy.Games.Game
  alias Jeopardy.Games.Category
  alias Jeopardy.Games.Clue
  alias Jeopardy.Users
  alias Jeopardy.Sessions
  alias Jeopardy.Sessions.Session
  alias JeopardyWeb.GameChannel
  alias JeopardyWeb.UserController
  action_fallback(JeopardyWeb.FallbackController)

  def index(conn, _params) do
    games = Games.list_games()
    render(conn, "index.json", games: games)
  end

  def alexa(conn, request) do
    #   [a | _] = Map.keys(request)

    #    { status, data} = JSON.decode(a) #request
    data = request
    IO.puts("#{Kernel.inspect(data)}")
    answer = data
    #    IO.puts("[DEBUG] Session:" <> answer["session"])
    session = answer["session"]
    request = answer["request"]

    if session["user"]["accessToken"] == nil do
      conn
      |> put_status(:ok)
      |> json(%{
        version: "1.0",
        response: %{
          outputSpeech: %{
            type: "PlainText",
            text:
              " Please use the companion app to authenticate on Amazon to start using this skill"
          },
          card: %{
            type: "LinkAccount"
          },
          shouldEndSession: false
        },
        sessionAttributes: %{}
      })
    else
      token = session["user"]["accessToken"]
      uProfile = UserController.retrieve_profile(token)
      userId = uProfile["user_id"]
      user = Users.get_or_create_user(userId)
      uSession = nil

      if user.unfinished_id do
        uSession = Sessions.get_session!(user.unfinished_id)
      end

    type = request["type"]
    intent = request["intent"]
    IO.puts("#{Kernel.inspect(intent)}")
    #    userId = session["user"]["userId"]
    #    accessToken = session["user"]["accessToken"]
    #    attributes = session["attributes"]
    #    answered_clues = attributes["clues"]
    #    game_id = attributes["game_id"]
    #    clue_list = attributes["questions"]
    #    user_input = answer["context"]
    # if new session, get user and new game
    cond do
       type == "LaunchRequest" ||
         (type == "IntentRequest" && request["intent"]["name"] == "newGame") ->
      if uSession do
        conn
        |> put_status(:ok)
        |> json(%{
          version: "1.0",
          sessionAttributes: %{
            clues: [],
            categories: [],
            answer: "",
            score: 0,
            numbered: [],
            session_id: uSession.id
            },
            response: %{
              outputSpeech: %{
                type: "PlainText",
                text: "You have an unfinished game. Do you want to continue?"
              },
              card: %{
                type: "Simple",
                title: "Jeopary",
                content: "You have an unfinished game. Do you want to continue?"
              },
              reprompt: %{
                outputSpeech: %{
                  type: "PlainText",
                  text: "Can I help you with anything else?"
                }
              },
              shouldEndSession: false
            }
          })
        else
          create(conn, data, user)
        end
    type == "IntentRequest" ->
      parse_answer(conn, data, user)
    type == "SessionEndedRequest" ->
      IO.puts("SESSION EDNED CUZ TIMEDOUT")
      conn
      |> put_status(:ok)
      |> json(%{
         version: "1.0",
         sessionAttributes: %{
          },
          response: %{
            outputSpeech: %{
              type: "PlainText",
              text: "Sorry! You have been timed out by the server. Please try to restart the game."
            },
            card: %{
              type: "Simple",
              title: "Jeopary",
              content: "Sorry! You have been timed out. Please try to restart ghe game"
            },
            reprompt: %{
              outputSpeech: %{
                type: "PlainText",
                text: "Please try to restart the game"
              }
            },
            shouldEndSession: true
          }
        })
    true ->
      conn
      |> put_status(:ok)
      |> json(%{})
    end
    end
  end

  def create(conn, data, user) do
    IO.puts("AYO YO #{Kernel.inspect(data)}")
    game_params = %{name: "random"}

    with {:ok, %Game{} = game} <- Games.create_game(game_params) do
      categories = create_categories_from_api(game)
      categories_id = Enum.map(categories, fn cat -> cat.id end)
      IO.puts("HEY YO #{Kernel.inspect(game)}")
      categories_list = Enum.map(categories, fn cat -> cat.title end)

      session_params = %{
        game_id: game.id,
        user_id: user.id,
        score: 0,
        answers: [],
        answered_clues: []
      }

      with {:ok, %Session{} = session} <- Sessions.create_session(session_params) do
        GameChannel.broadcast_change()

        numbered_categories_list =
          Enum.join(
            Enum.map([1, 2, 3, 4, 5], fn n ->
              Kernel.inspect(n) <> ". " <> Enum.at(categories_list, n - 1)
            end),
            ", "
          )

        unfinished = %{unfinished_id: session.id}
        Users.update_user(user, unfinished)

        conn
        |> put_status(:ok)
        |> json(%{
          version: "1.0",
          sessionAttributes: %{
            clues: [],
            categories: categories_id,
            chosenCat: -1,
            answer: "",
            score: 0,
            numbered: numbered_categories_list,
            session_id: session.id
          },
          response: %{
            outputSpeech: %{
              type: "PlainText",
              text:
                "New game with following categories: " <>
                  numbered_categories_list <> ". Please pick a number"
            },
            card: %{
              type: "Simple",
              title: "Jeopardy",
              content:
                "New game created with following categories: " <>
                  numbered_categories_list <> ". Please pick one number!"
            },
            reprompt: %{
              outputSpeech: %{
                type: "PlainText",
                text: "Can I help you with anything else?"
              }
            },
            shouldEndSession: false
          }
        })
      end
    end
  end

  def create_categories_from_api(game) do
    offset = Kernel.inspect(:rand.uniform(100))
    url = "http://jservice.io/api/categories?count=10&offset=" <> offset
    req = Poison.decode!(HTTPoison.get!(url).body)
    #    IO.puts("RESULT EY #{Kernel.inspect(req)}")

    valid_categories =
      Enum.filter(Enum.map(req, fn cat_req -> transform_category(cat_req, game) end), fn c ->
        c != nil
      end)

    # valid_categories |> Enum.with_index(1) |>Enum.map(fn {k,v}->{v,k} end) |> Map.new
    valid_categories
  end

  def transform_category(cat_req, game) do
    cat_params = %{title: cat_req["title"], game_id: game.id}
    cat_url = "http://jservice.io/api/category?id=" <> Kernel.inspect(cat_req["id"])
    cat = Poison.decode!(HTTPoison.get!(cat_url).body)

    if is_valid_category(cat) do
      with {:ok, %Category{} = category} <- Games.create_category(cat_params) do
        #        IO.puts("CAT #{Kernel.inspect(category)}")
        val = 200

        for n <- [0, 1, 2, 3, 4] do
          [clue_req | _] =
            Enum.filter(cat["clues"], fn clue -> clue["value"] == val * (n + 1) end)

          #          IO.puts("CLUE REQ #{Kernel.inspect(clue_req)}")
          if String.contains?(clue_req["answer"], "<") do
            IO.puts("CLUE #{clue_req["answer"]}")
            IO.puts("CLUE ANSWSER #{remove_tag(clue_req["answer"])}")
          end

          clue_params = %{
            answer: remove_tag(clue_req["answer"]),
            question: clue_req["question"],
            value: clue_req["value"],
            category_id: category.id
          }

          #          IO.puts("CLUE PARAMS #{Kernel.inspect(clue_params)}")
          Games.create_clue(clue_params)
        end

        category
      end
    else
      nil
    end
  end

  def is_valid_category(category) do
    clue_list = [0, 1, 2, 3, 4]

    valid_clues =
      Enum.filter(Enum.map(clue_list, fn n -> extract_clue(n, category) end), fn c -> c != nil end)

    Kernel.length(valid_clues) == 5
  end

  def extract_clue(n, category) do
    val = 200
    filtered = Enum.filter(category["clues"], fn cl -> cl["value"] == val * (n + 1) end)

    if filtered !== [] do
      [clue | _] = filtered
      clue
    else
      nil
    end
  end

  def remove_tag(word) do
    if String.contains?(word, ">") do
      Enum.at(String.split(Enum.at(String.split(word, ">", parts: 2), 1), "<", parts: 2), 0)
    else
      word
    end
  end

  def show(conn, %{"id" => id}) do
    game = Games.get_game!(id)
    render(conn, "show.json", game: game)
  end

  def update(conn, %{"id" => id, "game" => game_params}) do
    game = Games.get_game!(id)

    with {:ok, %Game{} = game} <- Games.update_game(game, game_params) do
      render(conn, "show.json", game: game)
    end
  end

  def delete(conn, %{"id" => id}) do
    game = Games.get_game!(id)

    with {:ok, %Game{}} <- Games.delete_game(game) do
      send_resp(conn, :no_content, "")
    end
  end

  def parse_answer(conn, data, user) do
    #    IO.puts("Parsing answer #{Kernel.inspect(data)}")
    answer = data
    session = answer["session"]
    #    user = session["user"]
    attributes = session["attributes"]
    categories = attributes["categories"]
    numbered_categories = attributes["numbered"]
    #    IO.puts("CATEGORIES #{Kernel.inspect(categories)}")
    answered_clues = attributes["clues"]
    clue_list = attributes["clues"]
    request = answer["request"]
    intent = request["intent"]
    name = intent["name"]
    sessionId = attributes["session_id"]

    if sessionId do
      IO.puts("USER #{Kernel.inspect(user)}")
      Users.update_user(user, %{unfinished_id: sessionId})
    end

    case name do
      "restartGame" ->
        if user.unfinished_id do
          IO.puts("CONTINUE GAME")
          uSession = Sessions.get_session!(user.unfinished_id)
          IO.puts("USESSION #{Kernel.inspect(uSession)}")
          len = Kernel.length(uSession.answered_clues)

          if len < 5 do
            uGameId = uSession.game.id
            categories = Games.get_category_by_game_id(uGameId)
            categories_id = Enum.map(categories, fn cat -> cat.id end)
            IO.puts("CAT #{Kernel.inspect(categories)}")
            categories_list = Enum.map(categories, fn cat -> cat.title end)

            numbered_categories_list =
              Enum.join(
                Enum.map([1, 2, 3, 4, 5], fn n ->
                  Kernel.inspect(n) <> ". " <> Enum.at(categories_list, n - 1)
                end),
                ", "
              )

            conn
            |> put_status(:ok)
            |> json(%{
              version: "1.0",
              sessionAttributes: %{
                clues: uSession.answered_clues,
                categories: categories_id,
                answer: "",
                score: uSession.score,
                numbered: numbered_categories_list,
                chosenCat: -1,
                session_id: uSession.id
              },
              response: %{
                outputSpeech: %{
                  type: "PlainText",
                  text:
                    "Continuing game. You have: " <>
                      Kernel.inspect(5 - len) <>
                      " questions left with following categories: " <>
                      numbered_categories_list <> ". Please pick a number"
                },
                card: %{
                  type: "Simple",
                  title: "Jeopary",
                  content:
                    "Continuing game. You have: " <>
                      Kernel.inspect(5 - len) <>
                      " with following categories: " <>
                      numbered_categories_list <> ". Please pick one number!"
                },
                reprompt: %{
                  outputSpeech: %{
                    type: "PlainText",
                    text: "Do you want to continue your game?"
                  }
                },
                shouldEndSession: false
              }
            })
          else
            IO.puts("CONT BUT NOT CONT")
            create(conn, data, user)
          end
        else
          IO.puts("CONTINUE BUT NEW GMAE")
          create(conn, data, user)
        end

      "chooseNumber" ->
        value = String.to_integer(intent["slots"]["number"]["value"])
        IO.puts("VAL #{Kernel.inspect(value)}")

        cond do
          value < 6 && value > 0 && attributes["chosenCat"] == -1 ->
            IO.puts("CHOOSE CAT")
            category_id = Enum.at(categories, value - 1)
            questions = Games.get_clue_by_category_id(category_id)

            value_questions =
              Enum.join(
                Enum.reverse(
                  Enum.map(
                    Enum.filter(questions, fn k -> !Enum.member?(answered_clues, k.id) end),
                    fn q -> Kernel.inspect(q.value) end
                  )
                ),
                ", "
              )

            conn
            |> put_status(:ok)
            |> json(%{
              version: "1.0",
              sessionAttributes: %{
                clues: clue_list,
                categories: categories,
                chosenCat: category_id,
                score: attributes["score"],
                answer: "",
                qValue: -1,
                numbered: numbered_categories,
                session_id: sessionId
              },
              response: %{
                outputSpeech: %{
                  type: "PlainText",
                  text:
                    "Current category has questions with following values: " <>
                      value_questions <> ". Please choose a question by its value"
                },
                card: %{
                  type: "Simple",
                  title: "Jeopardy",
                  content:
                    "Current category has questions with following valules: " <>
                      value_questions <> " Please choose a question by its value"
                },
                reprompt: %{
                  outputSpeech: %{
                    type: "PlainText",
                    text: "Please say the number that corresponds to the desired value"
                  }
                },
                shouldEndSession: false
              }
            })

          Enum.member?([200, 400, 600, 800, 1000], value) && attributes["chosenCat"] != -1 ->
            IO.puts("CHOSE QUESS")
            category_id = attributes["chosenCat"]
            IO.puts("QIESSSSSSSS #{Kernel.inspect(category_id)}")
            questions = Games.get_clue_by_category_id(category_id)
            score = attributes["score"]
            [question | _] = Enum.filter(questions, fn q -> q.value == value end)
            # TODO, make sur equestion is not asked before
            IO.puts("ANSWER IS #{question.answer}")

            conn
            |> put_status(:ok)
            |> json(%{
              version: "1.0",
              sessionAttributes: %{
                clues: [question.id] ++ clue_list,
                categories: categories,
                chosenCat: category_id,
                answer: question.answer,
                qValue: value,
                score: score,
                numbered: numbered_categories,
                session_id: sessionId
              },
              response: %{
                outputSpeech: %{
                  type: "PlainText",
                  text:
                    "The question you chose with value " <>
                      Kernel.inspect(value) <>
                      " is: " <> question.question <> ". Please provide an answer"
                },
                card: %{
                  type: "Simple",
                  title: "Jeopardy",
                  content:
                    "The question you chose is: " <>
                      question.question <> " Please provide an answer"
                },
                reprompt: %{
                  outputSpeech: %{
                    type: "PlainText",
                    text: "Please say what or who is followed by the answer"
                  }
                },
                shouldEndSession: false
              }
            })

          true ->
            conn
            |> put_status(:ok)
            |> json(%{
              version: "1.0",
              sessionAttributes: %{
                clues: attributes["clues"],
                categories: attributes["categories"],
                chosenCat: attributes["chosenCat"],
                answer: attributes["answer"],
                qValue: attributes["qValue"],
                score: attributes["score"],
                numbered: attributes["numbered"],
                session_id: attributes["session_id"]
              },
              response: %{
                outputSpeech: %{
                  type: "PlainText",
                  text:
                    "The value you provided is: " <>
                      Kernel.inspect(value) <> " which is invalid.  Please provide another value"
                },
                card: %{
                  type: "Simple",
                  title: "Jeopardy",
                  content:
                    "The value you provided is: " <>
                      Kernel.inspect(value) <> " which is invalid.  Please provide another value"
                },
                reprompt: %{
                  outputSpeech: %{
                    type: "PlainText",
                    text: "Please provide another value"
                  }
                },
                shouldEndSession: false
              }
            })
        end

      "answerResponse" ->
        IO.puts("ANSWER RES")
        value = String.downcase(intent["slots"]["answer"]["value"])
        correctA = String.downcase(attributes["answer"])
        score = attributes["score"]
        qValue = attributes["qValue"]
        len = Kernel.length(answered_clues)
        IO.puts("categories #{Kernel.inspect(value)}")

        if correctA =~ value || correctA =~ "the " <> value || correctA =~ "a " <> value do
          new_score = Kernel.inspect(score + qValue)

          if len >= 5 do
            Users.update_user(user, %{unfinished_id: nil})

            response_for_answer(
              conn,
              new_score,
              clue_list,
              value,
              numbered_categories,
              1,
              ". The game has ended. Your final score is " <>
                new_score <> ". Would you like to play another game?",
              attributes
            )
          else
            response_for_answer(
              conn,
              new_score,
              clue_list,
              value,
              numbered_categories,
              1,
              ". The correct answer is: " <>
                attributes["answer"] <>
                " .Your current score is: " <>
                new_score <>
                ". You have " <>
                Kernel.inspect(5 - len) <>
                " questions left. Category list: " <>
                numbered_categories <> ". Please choose a category",
              attributes
            )
          end
        else
          if len >= 5 do
            Users.update_user(user, %{unfinished_id: nil})

            response_for_answer(
              conn,
              Kernel.inspect(score),
              clue_list,
              value,
              numbered_categories,
              0,
              ". The correct answer is: " <>
                correctA <>
                ". The game has ended. Your final score is " <>
                Kernel.inspect(score) <> ". Would you like to play another game?",
              attributes
            )
          else
            response_for_answer(
              conn,
              Kernel.inspect(score),
              clue_list,
              value,
              numbered_categories,
              0,
              ". The correct answer is: " <>
                attributes["answer"] <>
                ". Your current score is " <>
                Kernel.inspect(score) <>
                ". You have " <>
                Kernel.inspect(5 - len) <>
                " questions left. Category list: " <>
                numbered_categories <> ". Please choose a category",
              attributes
            )
          end
        end

      "noGame" ->
        create(conn, data, user)

      _ ->
        IO.puts("WRONG DATA #{Kernel.inspect(data)}")

        conn
        |> put_status(:not_found)
        |> json(%{})
    end
  end

  def is_my_application(app_id) do
    app_id == "abcdef"
  end

  def response_for_answer(
        conn,
        new_score,
        clue_list,
        user_answer,
        categories_list,
        s,
        response,
        attributes
      ) do
    result = "correct"

    sessionId = attributes["session_id"]
    session = Sessions.get_session!(sessionId)

    categories = attributes["categories"]

    session_params = %{
      answered_clues: attributes["clues"],
      answers: [user_answer] ++ session.answers,
      score: String.to_integer(new_score)
    }

    Sessions.update_session(session, session_params)
    GameChannel.broadcast_change()

    if s == 0 do
      result = "wrong"
    end

    conn
    |> put_status(:ok)
    |> json(%{
      version: "1.0",
      sessionAttributes: %{
        clues: clue_list,
        categories: categories,
        answer: "",
        qValue: 0,
        score: String.to_integer(new_score),
        chosenCat: -1,
        numbered: categories_list,
        session_id: sessionId
      },
      response: %{
        outputSpeech: %{
          type: "PlainText",
          text: "You are " <> result <> response
        },
        card: %{
          type: "Simple",
          title: "Jeopardy",
          content: "You are " <> result <> response
        },
        reprompt: %{
          outputSpeech: %{
            type: "PlainText",
            text: "Can I help you with anything else?"
          }
        },
        shouldEndSession: false
      }
    })
  end

  @doc """
  {
      "version": "1.0",
      "session": {
       "new": false,
       "sessionId": "amzn1.echo-api.session.75ad6a8a-b138-4b53-bf6b-6382cf831c94",
       "application": {
         "applicationId": "amzn1.ask.skill.7c32ae68-f8b4-46f2-9b67-14eb2d2bb9f6"
       },
       "attributes": {
         "clues": []
       },
       "user": {
         "userId": "amzn1.ask.account.AHPBQ6IQ3HL66V3VT5RORXWRB5W4XFHQR2XY2YZS5PLGLD5ARLOJFD2YFQSSGGZXRNAIAAG67LV73CXMSRG3IDLDTJKDIT4DIFPHFXXKSSD7ZWU6247JTUZCDYLPYUYNSDHDMQLPY472DBAFNO5CEWDRDLMRIINJHUD2SRKZNC5BOZSXWEHNVHUZ5VRBXAGYBH7UJIH7LQMZVXA"
       }
      },
      "context": {
       "AudioPlayer": {
         "playerActivity": "IDLE"
       },
       "Display": {
         "token": ""
       },
       "System": {
         "application": {
           "applicationId": "amzn1.ask.skill.7c32ae68-f8b4-46f2-9b67-14eb2d2bb9f6"
         },
         "user": {
           "userId": "amzn1.ask.account.AHPBQ6IQ3HL66V3VT5RORXWRB5W4XFHQR2XY2YZS5PLGLD5ARLOJFD2YFQSSGGZXRNAIAAG67LV73CXMSRG3IDLDTJKDIT4DIFPHFXXKSSD7ZWU6247JTUZCDYLPYUYNSDHDMQLPY472DBAFNO5CEWDRDLMRIINJHUD2SRKZNC5BOZSXWEHNVHUZ5VRBXAGYBH7UJIH7LQMZVXA"
         },
         "device": {
           "deviceId": "amzn1.ask.device.AHKXQYKEMF5PT65UMB32N4RDPXJ4XYZ7GCJ6LXH2YAK7ZJ64Z6SXXOURT3AND4COTPUCLUPZ62NE4ZDAFQI2EH3PZYYZGFZ76NUZWYS4SPRHVV4ZSH3AV4W6K4G3VM6D3KFAF5GVGHHFARPKR4CDNG6TVMFAJCTSWDL5EQ54M34BL6ZZCOCMK",
           "supportedInterfaces": {
             "AudioPlayer": {},
             "Display": {
               "templateVersion": "1.0",
               "markupVersion": "1.0"
             }
           }
         },
         "apiEndpoint": "https://api.amazonalexa.com",
         "apiAccessToken": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IjEifQ.eyJhdWQiOiJodHRwczovL2FwaS5hbWF6b25hbGV4YS5jb20iLCJpc3MiOiJBbGV4YVNraWxsS2l0Iiwic3ViIjoiYW16bjEuYXNrLnNraWxsLjdjMzJhZTY4LWY4YjQtNDZmMi05YjY3LTE0ZWIyZDJiYjlmNiIsImV4cCI6MTUyMzc2MTkyMiwiaWF0IjoxNTIzNzU4MzIyLCJuYmYiOjE1MjM3NTgzMjIsInByaXZhdGVDbGFpbXMiOnsiY29uc2VudFRva2VuIjpudWxsLCJkZXZpY2VJZCI6ImFtem4xLmFzay5kZXZpY2UuQUhLWFFZS0VNRjVQVDY1VU1CMzJONFJEUFhKNFhZWjdHQ0o2TFhIMllBSzdaSjY0WjZTWFhPVVJUM0FORDRDT1RQVUNMVVBaNjJORTRaREFGUUkyRUgzUFpZWVpHRlo3Nk5VWldZUzRTUFJIVlY0WlNIM0FWNFc2SzRHM1ZNNkQzS0ZBRjVHVkdISEZBUlBLUjRDRE5HNlRWTUZBSkNUU1dETDVFUTU0TTM0Qkw2WlpDT0NNSyIsInVzZXJJZCI6ImFtem4xLmFzay5hY2NvdW50LkFIUEJRNklRM0hMNjZWM1ZUNVJPUlhXUkI1VzRYRkhRUjJYWTJZWlM1UExHTEQ1QVJMT0pGRDJZRlFTU0dHWlhSTkFJQUFHNjdMVjczQ1hNU1JHM0lETERUSktESVQ0RElGUEhGWFhLU1NEN1pXVTYyNDdKVFVaQ0RZTFBZVVlOU0RIRE1RTFBZNDcyREJBRk5PNUNFV0RSRExNUklJTkpIVUQyU1JLWk5DNUJPWlNYV0VITlZIVVo1VlJCWEFHWUJIN1VKSUg3TFFNWlZYQSJ9fQ.EM4MH3Q9JDjyfBgTOefII1oeZar11wn5YVU9AN0KGwi4MXnPY4__SWf-PFiTrA8JV6Ez3t7zai6g2NfXg9GAM3mIF0p5k9QYh6mlXcO5jcsyhTZtmZ5_gkGe7qUgBYPmABTbuVcaXct0vrW1R5aFEfMHG4ApmCdKBBV_e2XEc_TadRfilotetRCqdIXDXQIK9pEn0LS2vQKtVqVGeF2eadQ1z3BaY_ZLZa52nmzUmAptPJPHUIIp8jgfH2DcMfbzB736Jz2-4VK_Gr7vDO8qZccUS6sN59fr1SyBMYdN9v7KspHclSfRoqx_Yad0qt_6vCKZfUr1JXTWn4YPguIcWQ"
       }
      },
      "request": {
       "type": "IntentRequest",
       "requestId": "amzn1.echo-api.request.6e395145-c7f3-4338-9963-192bcea0ad00",
       "timestamp": "2018-04-15T02:12:02Z",
       "locale": "en-US",
       "intent": {
         "name": "chooseCategory",
         "confirmationStatus": "NONE",
         "slots": {
           "category_no": {
             "name": "category_no",
             "value": "1",
             "confirmationStatus": "NONE"
           }
         }
       },
       "dialogState": "STARTED"
      }
  }


  {
    "version": "1.0",
    "session": {
      "new": true,
      "sessionId": "amzn1.echo-api.session.[unique-value-here]",
      "application": {
        "applicationId": "amzn1.ask.skill.[unique-value-here]"
      },
      "attributes": {
        "key": "string value"
      },
      "user": {
        "userId": "amzn1.ask.account.[unique-value-here]",
        "accessToken": "Atza|AAAAAAAA...",
        "permissions": {
          "consentToken": "ZZZZZZZ..."
        }
      }
    },
    "context": {
      "System": {
        "device": {
          "deviceId": "string",
          "supportedInterfaces": {
            "AudioPlayer": {}
          }
        },
        "application": {
          "applicationId": "amzn1.ask.skill.[unique-value-here]"
        },
        "user": {
          "userId": "amzn1.ask.account.[unique-value-here]",
          "accessToken": "Atza|AAAAAAAA...",
          "permissions": {
            "consentToken": "ZZZZZZZ..."
          }
        },
        "apiEndpoint": "https://api.amazonalexa.com",
        "apiAccessToken": "AxThk..."
      },
      "AudioPlayer": {
        "playerActivity": "PLAYING",
        "token": "audioplayer-token",
        "offsetInMilliseconds": 0
      }
    },
    "request": {}
  }
  """
end
