defmodule JeopardyWeb.Plugs do
  import Plug.Conn

  alias Jeopardy.Sessions

  def fetch_user(conn, _opts) do
    user_id = get_session(conn, :user_id)
    if user_id do
      user = Jeopardy.Users.get_user!(user_id)
      assign(conn, :current_user, user)
    else
      assign(conn, :current_user, nil)
    end
  end


  def fetch_game_session(conn, _opts) do
    session_id = get_session(conn, :session_id)
    session = Sessions.get_or_create_session(session_id)
    conn
    |> put_session(:session_id, session.id)
    |> assign(:current_session, session)
  end
end
