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
end
