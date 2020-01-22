defmodule Jeopardy.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :score, :integer
      add :answered_clues, {:array, :integer}
      add :answers, {:array, :string}
      add :game_id, references(:games, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:sessions, [:game_id])
    create index(:sessions, [:user_id])
  end
end
