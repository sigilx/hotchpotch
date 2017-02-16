defmodule Hotchpotch.SessionControllerTest do
  use Hotchpotch.ConnCase

  alias Hotchpotch.{Repo, User}

  @valid_user_attrs %{email: "fakemail@gmail.com", username: "fakename", password: String.duplicate("o", 6)}

  test "renders form for new sessions", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "登录"
  end

  test "login user and redirect to home page when data is valid", %{conn: conn} do
    user_changeset = User.changeset(%User{}, @valid_user_attrs)
    user = Repo.insert! user_changeset

    conn = post conn, session_path(conn, :create), session: @valid_user_attrs
    assert get_flash(conn, :info) == "欢迎你"
    assert redirected_to(conn) == page_path(conn, :index)

    conn = get conn, page_path(conn, :index)
    assert html_response(conn, 200) =~ Map.get(@valid_user_attrs, :username)
    conn = get conn, user_path(conn, :show, user)
    assert html_response(conn, 200) =~ Map.get(@valid_user_attrs, :username)
  end

  test "redirect to session new when email exists but with wrong password", %{conn: conn} do
    user_changeset = User.changeset(%User{}, @valid_user_attrs)
    Repo.insert! user_changeset

    conn = post conn, session_path(conn, :create), session: %{@valid_user_attrs | password: ""}
    assert get_flash(conn, :error) == "用户名或密码错误"
    assert html_response(conn, 200) =~ "登录"
  end

  test "redirect to session new when nobody login", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @valid_user_attrs
    assert get_flash(conn, :error) == "用户名或密码错误"
    assert html_response(conn, 200) =~ "登录"
  end
end
