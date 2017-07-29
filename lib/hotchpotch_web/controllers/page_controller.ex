defmodule HotchpotchWeb.PageController do
  use HotchpotchWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
