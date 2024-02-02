defmodule TodolistappWeb.BoardLive.Index do
  use TodolistappWeb, :live_view

  alias Todolistapp.Tasks

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:to_do, Tasks.list_tasks(:to_do))
     |> stream(:in_progress, Tasks.list_tasks(:in_progress))
     |> stream(:completed, Tasks.list_tasks(:completed))}
  end

  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, :page_title, "Board")
  end

  def handle_event("sort", params, socket) do
    from_list = Map.get(params, "fromList")
    moved_id = Map.get(params, "movedId")
    next_sibling_id = Map.get(params, "nextSiblingId")
    previous_sibling_id = Map.get(params, "previousSiblingId")
    to_list = Map.get(params, "toList")
    if from_list == to_list do
      case Tasks.reorder_task(moved_id, previous_sibling_id, next_sibling_id) do
        {:ok, _} -> {:noreply, put_flash(socket, :info, "Task order updated successfully!")}
        {:error, _changeset} -> {:noreply, put_flash(socket, :error, "Unable to update task order.")}
      end
    else
      new_status =
        to_list
        |> String.replace_suffix("_items", "")
        |> String.to_atom()
      case Tasks.update_status_and_reorder(moved_id, new_status, previous_sibling_id, next_sibling_id) do
        {:ok, _} -> {:noreply, put_flash(socket, :info, "Task moved successfully!")}
        {:error, _changeset} -> {:noreply, put_flash(socket, :error, "Unable to move task.")}
      end
    end
    {:noreply, socket}
  end
end
