defmodule Jeopardy.Sessions do
  @moduledoc """
  The Sessions context.
  """

  import Ecto.Query, warn: false
  alias Jeopardy.Repo

  alias Jeopardy.Sessions.Session

  @doc """
  Returns the list of sessions.

  ## Examples

  iex> list_sessions()
  [%Session{}, ...]

  """
  def list_sessions do
    Repo.all(Session)
    |> Repo.preload(:user)
    |> Repo.preload(:game)
  end

  @doc """
  Gets a single session.

  Raises `Ecto.NoResultsError` if the Session does not exist.

  ## Examples

  iex> get_session!(123)
  %Session{}

  iex> get_session!(456)
  ** (Ecto.NoResultsError)

  """
  def get_session!(id), do:
    Repo.get!(Session, id)
    |> Repo.preload([:user, :game])


  @doc """
  Creates a session.

  ## Examples

  iex> create_session(%{field: value})
  {:ok, %Session{}}

  iex> create_session(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_session(attrs \\ %{}) do
    %Session{}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a session.

  ## Examples

  iex> update_session(session, %{field: new_value})
  {:ok, %Session{}}

  iex> update_session(session, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_session(%Session{} = session, attrs) do
    session
    |> Session.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Session.

  ## Examples

  iex> delete_session(session)
  {:ok, %Session{}}

  iex> delete_session(session)
  {:error, %Ecto.Changeset{}}

  """
  def delete_session(%Session{} = session) do
    Repo.delete(session)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking session changes.

  ## Examples

  iex> change_session(session)
  %Ecto.Changeset{source: %Session{}}

  """
  def change_session(%Session{} = session) do
    Session.changeset(session, %{})
  end

  def get_or_create_session(nil) do
    Repo.insert!(%Session{})
    |> Repo.preload([:user, :game])
  end

  def get_or_create_session(id) do
    session = Repo.get(Session, id)

    if session do
      session
      |> Repo.preload([:user, :game])
    else
      get_or_create_session(nil)
    end
  end

  def get_session_by_user_id(id) do
    Repo.all(from(s in Session, where: s.user_id == ^id))
  end
end
