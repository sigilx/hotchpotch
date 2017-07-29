defmodule HotchpotchWeb.BoardView do
  use HotchpotchWeb, :view

  def render("scripts.show.html", _assigns) do
    ~E{<script>require("web/static/js/board/board").Board.run()</script>}
  end
end
