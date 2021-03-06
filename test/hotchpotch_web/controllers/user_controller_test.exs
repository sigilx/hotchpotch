defmodule HotchpotchWeb.UserControllerTest do
  use HotchpotchWeb.ConnCase

  alias Hotchpotch.Repo
  alias HotchpotchWeb.User

  @valid_attrs %{email: "fake@gmail.com", password: "some content", nickname: "呆子"}
  @another_valid_attrs %{email: "fake+1@gmail.com", password: "some content", nickname: "傻子"}
  @invalid_attrs %{}

  setup %{conn: conn} = context do
    if context[:logged_in] == true do
      user = Repo.insert! User.changeset(%User{}, @valid_attrs)
      conn = post conn, session_path(conn, :create), session: @valid_attrs
      conn = put conn, user_path(conn, :update, user), user: %{@valid_attrs | nickname: "大傻", email: "fake+1@gmail.com"}
      {:ok, [conn: conn, user: user]}
    else
      :ok
    end
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "New user"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    assert redirected_to(conn) == page_path(conn, :index)
    assert Repo.get_by(User, @valid_attrs |> Map.delete(:password))

    conn = get conn, page_path(conn, :index)
    assert html_response(conn, 200) =~ Map.get(@valid_attrs, :nickname)

    assert html_response(conn, 200) =~ "退出"
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "New user"
  end

  @tag logged_in: true
  test "shows chosen resource", %{conn: conn, user: user} do
    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ "Show user"
  end

  @tag logged_in: true
  test "renders form for editing chosen resource", %{conn: conn, user: user} do
    conn = get conn, user_path(conn, :edit, user)
    assert html_response(conn, 200) =~ "Edit user"
  end

  @tag logged_in: true
  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
    conn = put conn, user_path(conn, :update, user), user: @another_valid_attrs
    assert redirected_to(conn) == user_path(conn, :show, user)
    assert Repo.get_by(User, @another_valid_attrs |> Map.delete(:password))
  end

  @tag logged_in: true
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit user"
  end

  test "guest access user action redirected to login page", %{conn: conn} do
    user = Repo.insert! User.changeset(%User{}, @valid_attrs)
    Enum.each([
      get(conn, user_path(conn, :show, user)),
      get(conn, user_path(conn, :edit, user)),
      put(conn, user_path(conn, :update, user), user: %{}),
    ], fn conn ->
      assert redirected_to(conn) == session_path(conn, :new)
      assert conn.halted
    end)
  end
end
