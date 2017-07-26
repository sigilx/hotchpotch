defmodule Hotchpotch.BoardControllerTest do
  use Hotchpotch.ConnCase

  alias Hotchpotch.{Repo, User, Board}
  @valid_attrs %{title: "ohmytitle"}
  @invalid_attrs %{}

  setup %{conn: conn} = context do
    user_attrs = %{email: "fake@gmail.com", nickname: "大傻", password: String.duplicate("1", 6)}
    user = Repo.insert! User.changeset(%User{}, user_attrs)
    if context[:logged_in] == true do
      conn = post conn, session_path(conn, :create), session: user_attrs
      {:ok, [conn: conn, user: user]}
    else
      :ok
    end
  end

  @tag logged_in: true
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, board_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing boards"
  end

  @tag logged_in: true
  test "renders form for new resources", %{conn: conn} do
    conn = get conn, board_path(conn, :new)
    assert html_response(conn, 200) =~ "New board"
  end

  @tag logged_in: true
  test "creates resource and redirects when data is valid", %{conn: conn, user: user} do
    conn = post conn, board_path(conn, :create), board: @valid_attrs
    assert redirected_to(conn) == board_path(conn, :index)
    assert Repo.get_by(Board, Map.put(@valid_attrs, :user_id, user.id))
  end

  @tag logged_in: true
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, board_path(conn, :create), board: @invalid_attrs
    assert html_response(conn, 200) =~ "New board"
  end

  @tag logged_in: true
  test "shows chosen resource", %{conn: conn, user: user} do
    board = Repo.insert! %Board{user_id: user.id}
    conn = get conn, board_path(conn, :show, board)
    assert html_response(conn, 200) =~ "ohmytitle"
  end

  @tag logged_in: true
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, board_path(conn, :show, -1)
    end
  end

  @tag logged_in: true
  test "renders form for editing chosen resource", %{conn: conn, user: user} do
    board = Repo.insert! %Board{user_id: user.id}
    conn = get conn, board_path(conn, :edit, board)
    assert html_response(conn, 200) =~ "Edit board"
  end

  @tag logged_in: true
  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
    board = Repo.insert! %Board{user_id: user.id}
    conn = put conn, board_path(conn, :update, board), board: @valid_attrs
    assert redirected_to(conn) == board_path(conn, :show, board)
    assert Repo.get_by(Board, @valid_attrs)
  end

  @tag logged_in: true
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    board = Repo.insert! %Board{user_id: user.id}
    conn = put conn, board_path(conn, :update, board), board: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit board"
  end

  @tag logged_in: true
  test "deletes chosen resource", %{conn: conn, user: user} do
    board = Repo.insert! %Board{user_id: user.id}
    conn = delete conn, board_path(conn, :delete, board)
    assert redirected_to(conn) == board_path(conn, :index)
    refute Repo.get(Board, board.id)
  end

  @tag logged_in: true
  test "user should allowed to show board of other people", %{conn: conn, user: user} do
    conn = post conn, board_path(conn, :create), board: @valid_attrs
    board = Repo.get_by(Board, Map.put(@valid_attrs, :user_id, user.id))
    new_user_attrs = %{email: "fake+1@gmail.com", "nickname": "二傻", password: String.duplicate("1", 6)}
    Repo.insert! User.changeset(%User{}, new_user_attrs)
    conn = post conn, session_path(conn, :create), session: new_user_attrs
    conn = get conn, board_path(conn, :show, board)
    assert html_response(conn, 200) =~ "ohmytitle"
  end

  test "guest access user action redirected to login page", %{conn: conn} do
    board = Repo.insert! %Board{}
    Enum.each([
      get(conn, board_path(conn, :index)),
      get(conn, board_path(conn, :new)),
      get(conn, board_path(conn, :create), board: %{}),
      get(conn, board_path(conn, :show, board)),
      get(conn, board_path(conn, :edit, board)),
      put(conn, board_path(conn, :update, board), board: %{}),
      put(conn, board_path(conn, :delete, board)),
    ], fn conn ->
      assert redirected_to(conn) == session_path(conn, :new)
      assert conn.halted
    end)
  end
end
