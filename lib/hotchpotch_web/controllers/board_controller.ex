defmodule HotchpotchWeb.BoardController do
  use HotchpotchWeb, :controller
  use HotchpotchWeb.Controller

  plug :login_required
  alias Hotchpotch.Boards
  alias Hotchpotch.Boards.Board

  def index(conn, _params, _current_user) do
    boards = Boards.list_boards()
    render(conn, "index.html", boards: boards)
  end

  def new(conn, _params, _current_user) do
    changeset = Boards.change_board(%Board{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"board" => board_params}, current_user) do
    case Boards.create_board_for_user(current_user, board_params) do
      {:ok, _board} ->
        conn
        |> put_flash(:info, "Board created successfully.")
        |> redirect(to: board_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user) do
    board = Boards.get_board!(id)
    render(conn, "show.html", board: board)
  end

  def edit(conn, %{"id" => id}, _current_user) do
    board = Boards.get_board!(id)
    changeset = Boards.change_board(board)
    render(conn, "edit.html", board: board, changeset: changeset)
  end

  def update(conn, %{"id" => id, "board" => board_params}, _current_user) do
    board = Boards.get_board!(id)

    case Boards.update_board(board, board_params) do
      {:ok, board} ->
        conn
        |> put_flash(:info, "Board updated successfully.")
        |> redirect(to: board_path(conn, :show, board))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", board: board, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _current_user) do
    board = Boards.get_board!(id)
    {:ok, _board} = Boards.delete_board(board)

    conn
    |> put_flash(:info, "Board deleted successfully.")
    |> redirect(to: board_path(conn, :index))
  end
end
