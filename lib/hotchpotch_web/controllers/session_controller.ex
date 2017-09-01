defmodule HotchpotchWeb.SessionController do
  use HotchpotchWeb, :controller

  alias Hotchpotch.Accounts
  alias HotchpotchWeb.Plugs.Auth

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_by_email_password(email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "欢迎回来!")
        |> Auth.login(user)
        |> redirect(to: "/")
      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "用户名或密码错误")
        |> redirect(to: session_path(conn, :new))
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, "退出成功")
    |> redirect(to: "/")
  end
end
