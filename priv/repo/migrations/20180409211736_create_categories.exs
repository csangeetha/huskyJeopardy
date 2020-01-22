defmodule Jeopardy.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :title, :string
      add :game_id, references(:games, on_delete: :nothing), null: false

      timestamps()
    end

  end
end
