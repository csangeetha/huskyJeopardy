defmodule Jeopardy.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :amazon_uid, :string
      add :name, :string
      add :unfinished_id, :integer

      timestamps()
    end

  end
end
