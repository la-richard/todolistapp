defmodule Todolistapp.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string, null: false
      add :details, :text
      add :status, :string, default: "to_do", null: false
      add :rank, :string, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
