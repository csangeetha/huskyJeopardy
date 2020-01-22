defmodule Jeopardy.Repo.Migrations.CreateClues do
  use Ecto.Migration

  def change do
    create table(:clues) do
      add :question, :string, null: false
      add :answer, :string, null: false
      add :value, :integer, null: false
      add :category_id, references(:categories, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:clues, [:category_id])
  end
end
