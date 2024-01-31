defmodule Todolistapp.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias Todolistapp.Repo

  alias Todolistapp.Tasks.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(from(t in Task, order_by: [asc: t.rank]))
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(Map.merge(%{"rank" => rank_created_task()}, attrs))
    |> Repo.insert()
  end

  defp rank_created_task do
    highest_rank_task = Repo.one(from(t in Task, order_by: [desc: t.rank], limit: 1));

    if highest_rank_task, do: "5000", else: get_next_unique_rank(increment_rank(highest_rank_task.rank))
  end

  defp get_next_unique_rank(rank) do
    task = Repo.one(from(t in Task, where: t.rank == ^rank))

    if task, do: rank, else: get_next_unique_rank(increment_rank(rank, 5))
  end

  defp increment_rank(rank, step \\ 100) do
    to_string(String.to_integer(rank) + step)
  end

  defp get_prev_unique_rank(rank) do
    task = Repo.one(from(t in Task, where: t.rank == ^rank))

    if task, do: rank, else: get_prev_unique_rank(decrement_rank(rank, 5))
  end

  defp decrement_rank(rank, step \\ 100) do
    to_string(String.to_integer(rank) - step)
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  def reorder_task(task_id, previous_task_id, next_task_id) do
    task = Repo.get(Task, task_id)
    previous_task = if previous_task_id, do: Repo.get(Task, previous_task_id), else: nil
    next_task = if next_task_id, do: Repo.get(Task, next_task_id), else: nil

    rank = rank_reordered_task(
      previous_task,
      next_task
    )

    task
    |> Task.changeset(%{"rank" => rank})
    |> Repo.update()
  end

  defp rank_reordered_task(nil, next_task) do
    get_prev_unique_rank(decrement_rank(next_task.rank))
  end

  defp rank_reordered_task(previous_task, nil) do
    get_next_unique_rank(increment_rank(previous_task.rank))
  end

  defp rank_reordered_task(previous_task, next_task) do
    previous_rank = String.to_integer(previous_task.rank)
    next_rank = String.to_integer(next_task.rank)
    distance = abs(next_rank - previous_rank)
    new_rank = to_string(previous_rank + div(distance, 2))

    get_next_unique_rank(new_rank)
  end
end
