defmodule TodolistappWeb.TaskControllerTest do
  use TodolistappWeb.ConnCase

  import Todolistapp.TasksFixtures

  @create_attrs %{status: :to_do, title: "some title", details: "some details"}
  @update_attrs %{status: :in_progress, title: "some updated title", details: "some updated details"}
  @invalid_attrs %{status: nil, title: nil, details: nil}

  describe "index" do
    test "lists all tasks", %{conn: conn} do
      conn = get(conn, ~p"/")
      assert html_response(conn, 200) =~ "Tasks"
    end
  end

  describe "new task" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/new")
      assert html_response(conn, 200) =~ "New Task"
    end
  end

  describe "create task" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/", task: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/#{id}"

      conn = get(conn, ~p"/#{id}")
      assert html_response(conn, 200) =~ "some title"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/", task: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Task"
    end
  end

  describe "edit task" do
    setup [:create_task]

    test "renders form for editing chosen task", %{conn: conn, task: task} do
      conn = get(conn, ~p"/#{task}/edit")
      assert html_response(conn, 200) =~ "Edit #{task.title}"
    end
  end

  describe "update task" do
    setup [:create_task]

    test "redirects when data is valid", %{conn: conn, task: task} do
      conn = put(conn, ~p"/#{task}", task: @update_attrs)
      assert redirected_to(conn) == ~p"/#{task}"

      conn = get(conn, ~p"/#{task}")
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, task: task} do
      conn = put(conn, ~p"/#{task}", task: @invalid_attrs)
      assert html_response(conn, 200) =~ "#{task.title}"
    end
  end

  describe "delete task" do
    setup [:create_task]

    test "deletes chosen task", %{conn: conn, task: task} do
      conn = delete(conn, ~p"/#{task}")
      assert redirected_to(conn) == ~p"/"

      assert_error_sent 404, fn ->
        get(conn, ~p"/#{task}")
      end
    end
  end

  defp create_task(_) do
    task = task_fixture()
    %{task: task}
  end
end
