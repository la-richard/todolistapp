defmodule TodolistappWeb.TaskLive.Index do
  use TodolistappWeb, :live_view

  alias Todolistapp.Tasks
  alias Todolistapp.Tasks.Task

  def mount(_params, _session, socket) do
    {:ok, stream(socket, :tasks, Tasks.list_tasks())}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Task{})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, Tasks.get_task!(id))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "To-Do List")
    |> assign(:task, nil)
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    task = Tasks.get_task!(id)
    socket
    |> assign(:page_title, task.title)
    |> assign(:task, task)
  end

  def handle_info({TodolistappWeb.TaskLive.TaskForm, {:saved, task}}, socket) do
    {:noreply, stream_insert(socket, :tasks, task)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.delete_task(task)

    {:noreply, socket |> stream_delete(:tasks, task) |> put_flash(:info, "Task deleted successfully!")}
  end

  def handle_event("sort", params, socket) do
    moved_id = Map.get(params, "movedId")
    next_sibling_id = Map.get(params, "nextSiblingId")
    previous_sibling_id = Map.get(params, "previousSiblingId")
    case Tasks.reorder_task(moved_id, previous_sibling_id, next_sibling_id) do
      {:ok, _} -> {:noreply, put_flash(socket, :info, "Task order updated successfully!")}
      {:error, _changeset} -> {:noreply, put_flash(socket, :error, "Unable to update task order.")}
    end
  end

end
