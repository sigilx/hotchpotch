defmodule Hotchpotch.SessionController do
  use Hotchpotch.Web, :controller
  alias Hotchpotch.{Repo, User}

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    user = Repo.get_by(User, email: email)
    cond do
      user && Comeonin.Bcrypt.checkpw(password, user.password_hash) ->
        conn
        |> put_flash(:info, "欢迎你")
        |> Hotchpotch.Auth.login(user)
        |> redirect(to: page_path(conn, :index))
      user ->
        conn
        |> put_flash(:error, "用户名或密码错误")
        |> render("new.html")
      true ->
        Comeonin.Bcrypt.dummy_checkpw()
        conn
        |> put_flash(:error, "用户名或密码错误")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "退出成功")
    |> redirect(to: page_path(conn, :index))
  end
end