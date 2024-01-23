defmodule Todolistapp.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todolistapp.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        details: "some details",
        status: :to_do,
        title: "some title"
      })
      |> Todolistapp.Tasks.create_task()

    task
  end
end
