defmodule HotchpotchWeb.BoarddrawChannel do
    use HotchpotchWeb, :channel

    def join("board:draw:lobby", payload, socket) do
      if authorized?(payload) do
        {:ok, socket}
      else
        {:error, %{reason: "unauthorized"}}
      end
    end

    def join("board:draw:" <> _board_id, payload, socket) do
      if authorized?(payload) do
        {:ok, socket}
      else
        {:error, %{reason: "unauthorized"}}
      end
    end

    def handle_in("drawing", payload, socket) do
      broadcast! socket, "drawing", payload
      {:noreply, socket}
    end

    # Add authorization logic here as required.
    defp authorized?(_payload) do
      true
    end
  end
