defmodule Hotchpotch.BoardController do
  use Hotchpotch.Web, :controller

  plug :login_require
  alias Hotchpotch.Board

  def index(conn, _params) do
    boards = Repo.all(Board)
    render(conn, "index.html", boards: boards)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns.current_user
      |> build_assoc(:board)
      |> Board.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"board" => board_params}) do
    changeset =
      conn.assigns.current_user
      |> build_assoc(:board)
      |> Board.changeset(board_params)

    case Repo.insert(changeset) do
      {:ok, _board} ->
        conn
        |> put_flash(:info, "Board created successfully.")
        |> redirect(to: board_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    board = Repo.get!(assoc(conn.assigns.current_user, :board), id)
    render(conn, "show.html", board: board)
  end

  def edit(conn, %{"id" => id}) do
    board = Repo.get!(assoc(conn.assigns.current_user, :board), id)
    changeset = Board.changeset(board)
    render(conn, "edit.html", board: board, changeset: changeset)
  end

  def update(conn, %{"id" => id, "board" => board_params}) do
    board = Repo.get!(assoc(conn.assigns.current_user, :board), id)
    changeset = Board.changeset(board, board_params)

    case Repo.update(changeset) do
      {:ok, board} ->
        conn
        |> put_flash(:info, "Board updated successfully.")
        |> redirect(to: board_path(conn, :show, board))
      {:error, changeset} ->
        render(conn, "edit.html", board: board, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    board = Repo.get!(assoc(conn.assigns.current_user, :board), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(board)

    conn
    |> put_flash(:info, "Board deleted successfully.")
    |> redirect(to: board_path(conn, :index))
  end
end
