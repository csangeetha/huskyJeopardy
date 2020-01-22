defmodule JeopardyWeb.ClueController do
  use JeopardyWeb, :controller

  alias Jeopardy.Games
  alias Jeopardy.Games.Clue

  action_fallback JeopardyWeb.FallbackController

  def index(conn, _params) do
    clues = Games.list_clues()
    render(conn, "index.json", clues: clues)
  end

  def create(conn, %{"clue" => clue_params}) do
    with {:ok, %Clue{} = clue} <- Games.create_clue(clue_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", clue_path(conn, :show, clue))
      |> render("show.json", clue: clue)
    end
  end

  def show(conn, %{"id" => id}) do
    clue = Games.get_clue!(id)
    render(conn, "show.json", clue: clue)
  end

  def update(conn, %{"id" => id, "clue" => clue_params}) do
    clue = Games.get_clue!(id)

    with {:ok, %Clue{} = clue} <- Games.update_clue(clue, clue_params) do
      render(conn, "show.json", clue: clue)
    end
  end

  def delete(conn, %{"id" => id}) do
    clue = Games.get_clue!(id)
    with {:ok, %Clue{}} <- Games.delete_clue(clue) do
      send_resp(conn, :no_content, "")
    end
  end
end
