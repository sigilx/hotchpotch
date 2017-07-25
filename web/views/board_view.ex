defmodule Hotchpotch.BoardView do
  use Hotchpotch.Web, :view

  def render("scripts.show.html", _assigns) do
    ~E{<script>require("web/static/js/board/board").Board.run()</script>}
  end
end
