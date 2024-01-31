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

  def handle_info({TodolistappWeb.TaskLive.TaskForm, {:saved, task}}, socket) do
    {:noreply, stream_insert(socket, :tasks, task)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.delete_task(task)

    {:noreply, socket |> stream_delete(:tasks, task) |> put_flash(:info, "Task deleted successfully!")}
  end

  def handle_event("sort", params, socket) do
    Tasks.reorder_task(
      Map.get(params, "movedId"),
      Map.get(params, "previousSiblingId"),
      Map.get(params, "nextSiblingId")
    )
    {:noreply, socket}
  end

end
