defmodule TodolistappWeb.TaskStatus do
  use Phoenix.Component

  import TodolistappWeb.CoreComponents

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

  defp status_icon_name(status) do
    case status do
      :to_do -> "hero-question-mark-circle"
      :in_progress -> "hero-ellipsis-horizontal-circle"
      :completed -> "hero-check-circle"
    end
  end

  defp status_icon_color_class(status) do
    case status do
      :to_do -> "bg-neutral-700"
      :in_progress -> "bg-yellow-700"
      :completed -> "bg-green-700"
    end
  end

  attr :status, :atom, required: true

  def task_status(assigns) do
    ~H"""
    <div class="flex flex-row items-center gap-2" title={format_status(@status)}>
      <.icon name={status_icon_name(@status)} class={status_icon_color_class(@status)} />
    </div>
    """
  end
end
