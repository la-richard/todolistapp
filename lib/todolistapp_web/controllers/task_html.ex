defmodule TodolistappWeb.TaskHTML do
  use TodolistappWeb, :html

  embed_templates "task_html/*"

  @doc """
  Renders a task form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def task_form(assigns)

  def format_status(status) do
    word_list = status
      |> Atom.to_string()
      |> String.split("_")

    proper_words_list = for word <- word_list, do: String.capitalize(word)

    Enum.join(proper_words_list, " ")
  end

  def get_status_opts do
    for value <- Ecto.Enum.values(Todolistapp.Tasks.Task, :status), do: {format_status(value), value}
  end
end
