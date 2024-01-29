defmodule TodolistappWeb.TaskLive.Show do
  use TodolistappWeb, :live_view

  alias Todolistapp.Tasks

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _, socket) do
    {:noreply, socket |> assign(:page_title, page_title(socket.assigns.live_action)) |> assign(:task, Tasks.get_task!(id))}
  end

  defp page_title(:show), do: "Task Info"
  defp page_title(:edit), do: "Edit Task"
end
