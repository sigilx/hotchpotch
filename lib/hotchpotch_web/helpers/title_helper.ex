defmodule HotchpotchWeb.Helpers.TitleHelper do
  alias HotchpotchWeb.{SessionView, UserView, BoardView}

  @suffix "嘿嘿黑板"

  def page_title(assigns), do: assigns |> get |> put_suffix

  defp put_suffix(nil), do: @suffix
  defp put_suffix(title), do: title <> " - " <> @suffix

  defp get(%{view_module: SessionView}), do: "登录"

  defp get(%{view_module: UserView, view_template: "new.html"}), do: "注册"
  defp get(%{view_module: UserView, view_template: "show.html"}), do: "账户"

  defp get(%{view_module: BoardView, view_template: "new.html"}), do: "新建黑板"
  defp get(%{view_module: BoardView, view_template: "show.html", board: board}) do
    board.title
  end
  defp get(%{view_module: BoardView, view_template: "edit.html", board: board}) do
    "编辑 " <> board.title
  end
  defp get(%{view_module: BoardView,}), do: "黑板"

  defp get(_), do: nil
end