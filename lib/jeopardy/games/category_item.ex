defmodule Jeopardy.Games.CategoryItem do
  use Ecto.Schema
  import Ecto.Changeset

  alias Jeopardy.Games.CategoryItem

  schema "category_items" do
    belongs_to :category, Jeopardy.Games.Category
    belongs_to :game, Jeopardy.Games.Game
 
    timestamps()
  end

  @doc false
  def changeset(%CategoryItem{} = category_item, attrs) do
    category_item
    |> cast(attrs, [:category_id, :game_id])
    |> validate_required([:category_id, :game_id])
  end
end
