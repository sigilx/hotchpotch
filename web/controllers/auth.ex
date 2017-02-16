defmodule Hotchpotch.Auth do
  import Plug.Conn

  @doc """
  初始化选项

  """
  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(Hotchpotch.User, user_id)
    assign(conn, :current_user, user)
  end

end
