defmodule JeopardyWeb.GameChannel do
  use JeopardyWeb, :channel
  alias Jeopardy.Game

  def join("game:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, %{sessions: Game.fetch_sessions()}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def broadcast_change() do
    payload = %{sessions: Game.fetch_sessions()}
    JeopardyWeb.Endpoint.broadcast("game:lobby", "change", payload)
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
