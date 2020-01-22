defmodule Jeopardy.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias Jeopardy.Repo

  alias Jeopardy.Games.Game

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)
  
  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{source: %Game{}}

  """
  def change_game(%Game{} = game) do
    Game.changeset(game, %{})
  end

  alias Jeopardy.Games.Category

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  def get_category_by_game_id(id) do
    Repo.all(from c in Category, where: c.game_id == ^id)
  end

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end

  alias Jeopardy.Games.Clue

  @doc """
  Returns the list of clues.

  ## Examples

      iex> list_clues()
      [%Clue{}, ...]

  """
  def list_clues do
    Repo.all(Clue)
  end

  @doc """
  Gets a single clue.

  Raises `Ecto.NoResultsError` if the Clue does not exist.

  ## Examples

      iex> get_clue!(123)
      %Clue{}

      iex> get_clue!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clue!(id), do: Repo.get!(Clue, id)

  def get_clue_by_category_id(id) do
    IO.puts("#{id}") 
    Repo.all(from c in Clue, where: c.category_id == ^id)    
  end

  @doc """
  Creates a clue.

  ## Examples

      iex> create_clue(%{field: value})
      {:ok, %Clue{}}

      iex> create_clue(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clue(attrs \\ %{}) do
    %Clue{}
    |> Clue.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a clue.

  ## Examples

      iex> update_clue(clue, %{field: new_value})
      {:ok, %Clue{}}

      iex> update_clue(clue, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clue(%Clue{} = clue, attrs) do
    clue
    |> Clue.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Clue.

  ## Examples

      iex> delete_clue(clue)
      {:ok, %Clue{}}

      iex> delete_clue(clue)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clue(%Clue{} = clue) do
    Repo.delete(clue)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clue changes.

  ## Examples

      iex> change_clue(clue)
      %Ecto.Changeset{source: %Clue{}}

  """
  def change_clue(%Clue{} = clue) do
    Clue.changeset(clue, %{})
  end

  alias Jeopardy.Games.CategoryItem

  @doc """
  Returns the list of category_items.

  ## Examples

      iex> list_category_items()
      [%CategoryItem{}, ...]

  """
  def list_category_items do
    Repo.all(CategoryItem)
  end

  @doc """
  Gets a single category_item.

  Raises `Ecto.NoResultsError` if the Category  item does not exist.

  ## Examples

      iex> get_category_item!(123)
      %CategoryItem{}

      iex> get_category_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category_item!(id), do: Repo.get!(CategoryItem, id)

  @doc """
  Creates a category_item.

  ## Examples

      iex> create_category_item(%{field: value})
      {:ok, %CategoryItem{}}

      iex> create_category_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category_item(attrs \\ %{}) do
    %CategoryItem{}
    |> CategoryItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category_item.

  ## Examples

      iex> update_category_item(category_item, %{field: new_value})
      {:ok, %CategoryItem{}}

      iex> update_category_item(category_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category_item(%CategoryItem{} = category_item, attrs) do
    category_item
    |> CategoryItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a CategoryItem.

  ## Examples

      iex> delete_category_item(category_item)
      {:ok, %CategoryItem{}}

      iex> delete_category_item(category_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category_item(%CategoryItem{} = category_item) do
    Repo.delete(category_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category_item changes.

  ## Examples

      iex> change_category_item(category_item)
      %Ecto.Changeset{source: %CategoryItem{}}

  """
  def change_category_item(%CategoryItem{} = category_item) do
    CategoryItem.changeset(category_item, %{})
  end
end
