defmodule Todolistapp.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :status, Ecto.Enum, values: [:to_do, :in_progress, :completed], default: :to_do
    field :title, :string
    field :details, :string
    field :rank, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :details, :status, :rank])
    |> validate_required([:title, :status, :rank])
    |> unique_constraint(:rank)
  end

end
