defmodule JeopardyWeb.SessionController do
  use JeopardyWeb, :controller

  alias Jeopardy.Sessions
  alias Jeopardy.Sessions.Session
  alias Jeopardy.Users

  action_fallback(JeopardyWeb.FallbackController)

  def index(conn, _params) do
    sessions = Sessions.list_sessions()
    render(conn, "index.json", sessions: sessions)
  end

  def create(conn, %{"session" => session_params}) do
    with {:ok, %Session{} = session} <- Sessions.create_session(session_params) do
      JeopardyWeb.GameChannel.broadcast_change()
      conn
      |> put_status(:created)
      |> put_resp_header("location", session_path(conn, :show, session))
      |> render("show.json", session: session)
    end
  end

  def show(conn, %{"id" => id}) do
    session = Sessions.get_session!(id)
    render(conn, "show.json", session: session)
  end

  def update(conn, %{"id" => id, "session" => session_params}) do
    session = Sessions.get_session!(id)

    with {:ok, %Session{} = session} <- Sessions.update_session(session, session_params) do
      JeopardyWeb.GameChannel.broadcast_change()
      render(conn, "show.json", session: session)
    end
  end

  def delete(conn, %{"id" => id}) do
    session = Sessions.get_session!(id)

    with {:ok, %Session{}} <- Sessions.delete_session(session) do
      send_resp(conn, :no_content, "")
    end
  end

  def login(conn, %{"name" => name}) do
    user = Users.get_user_by_name(name)

    if user do
      session = conn.assigns[:current_session]
      Sessions.update_session(session, %{user_id: user.id})

      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Logged in as #{user.name}")
      |> redirect(to: game_path(conn, :index))
    else
      conn
      |> put_session(:user_id, nil)
      |> put_flash(:error, "No such user")
      |> redirect(to: game_path(conn, :index))
    end
  end

  def logout(conn, _args) do
    conn
    |> put_session(:user_id, nil)
    |> put_session(:session_id, nil)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: game_path(conn, :index))
  end
end
