defmodule HotchpotchWeb.BoarddrawChannel do
    use HotchpotchWeb, :channel

    alias Hotchpotch.Boards

    def join("board:draw:lobby", payload, socket) do
      if authorized?(payload) do
        {:ok, socket}
      else
        {:error, %{reason: "unauthorized"}}
      end
    end

    def join("board:draw:" <> board_id, payload, socket) do
      board = Boards.get_board!(board_id)
      if authorized?(payload) do
        {:ok, socket}
      else
        {:error, %{reason: "unauthorized"}}
      end
    end

    def handle_in("drawing", %{"x0" => x0, "y0" => y0, "x1" => x1, "y1" => y1, "color" => color} = payload, socket) do
      broadcast! socket, "drawing", payload
      {:noreply, socket}
    end

    # Add authorization logic here as required.
    defp authorized?(_payload) do
      true
    end
  end
