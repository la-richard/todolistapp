defmodule TodolistappWeb.TaskLive.TaskForm do
  use TodolistappWeb, :live_component

  alias Todolistapp.Tasks

  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage foo records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="task-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:details]} type="textarea" label="Details (Optional)" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          prompt="Choose a value"
          options={get_status_opts()}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Task</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def update(%{task: task} = assigns, socket) do
    changeset = Tasks.change_task(task)
    {:ok, socket |> assign(assigns) |> assign(:form, to_form(changeset))}
  end

  def handle_event("validate", %{"task" => task_params}, socket) do
    changeset = socket.assigns.task
      |> Tasks.change_task(task_params)
      |> Map.put(:action, :validate)

      {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"task" => task_params}, socket) do
    save_task(socket, socket.assigns.action, task_params)
  end

  defp save_task(socket, :edit, task_params) do
    case Tasks.update_task(socket.assigns.task, task_params) do
      {:ok, task} ->
        notify_parent({:saved, task})

        {:noreply, socket |> put_flash(:info, "Task updated successfully!") |> push_patch(to: socket.assigns.patch)}
      {:error, %Ecto.Changeset{} = changeset} -> {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp save_task(socket, :new, task_params) do
    case Tasks.create_task(task_params) do
      {:ok, task} ->
        notify_parent({:saved, task})

        {:noreply, socket |> put_flash(:info, "Task created successfully!") |> push_patch(to: socket.assigns.patch)}
      {:error, %Ecto.Changeset{} = changeset} -> {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
