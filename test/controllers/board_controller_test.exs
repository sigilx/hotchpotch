defmodule Hotchpotch.BoardControllerTest do
  use Hotchpotch.ConnCase

  alias Hotchpotch.{Repo, User, Board}
  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  setup do
    user = Repo.insert! User.changeset(%User{}, %{email: "fake@gmail.com", username: "fakename", password: String.duplicate("1", 6)})
    attrs = Map.put(@valid_attrs, :user_id, user.id)
    {:ok, [attrs: attrs]}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, board_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing boards"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, board_path(conn, :new)
    assert html_response(conn, 200) =~ "New board"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, attrs: attrs} do
    conn = post conn, board_path(conn, :create), board: attrs
    assert redirected_to(conn) == board_path(conn, :index)
    assert Repo.get_by(Board, attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, board_path(conn, :create), board: @invalid_attrs
    assert html_response(conn, 200) =~ "New board"
  end

  test "shows chosen resource", %{conn: conn} do
    board = Repo.insert! %Board{}
    conn = get conn, board_path(conn, :show, board)
    assert html_response(conn, 200) =~ "Show board"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, board_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    board = Repo.insert! %Board{}
    conn = get conn, board_path(conn, :edit, board)
    assert html_response(conn, 200) =~ "Edit board"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, attrs: attrs} do
    board = Repo.insert! %Board{}
    conn = put conn, board_path(conn, :update, board), board: attrs
    assert redirected_to(conn) == board_path(conn, :show, board)
    assert Repo.get_by(Board, attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    board = Repo.insert! %Board{}
    conn = put conn, board_path(conn, :update, board), board: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit board"
  end

  test "deletes chosen resource", %{conn: conn} do
    board = Repo.insert! %Board{}
    conn = delete conn, board_path(conn, :delete, board)
    assert redirected_to(conn) == board_path(conn, :index)
    refute Repo.get(Board, board.id)
  end
end
