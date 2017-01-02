defmodule Hotchpotch.PageController do
  use Hotchpotch.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
