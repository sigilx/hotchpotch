defmodule HotchpotchWeb.BoardView do
  use HotchpotchWeb, :view

  def render("scripts.show.html", _assigns) do
    ~E{<script src="/js/board.js"></script>}
  end
end
