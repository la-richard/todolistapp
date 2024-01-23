defmodule Todolistapp.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :status, Ecto.Enum, values: [:to_do, :in_progress, :completed], default: :to_do
    field :title, :string
    field :details, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :details, :status])
    |> validate_required([:title, :status])
  end

end
