defmodule Hotchpotch.BoardChannel do
  use Hotchpotch.Web, :channel

  alias Hotchpotch.{Repo, Board}

  def join("board:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("board:" <> board_id, _payload, _socket) do
    board = Repo.get!(Board, board_id)
  end

	def handle_in("new_msg", %{"body" => body, "isSystem" => is_system}, socket) do
    broadcast! socket, "new_msg", %{body: body, is_system: is_system}
    IO.inspect body
    {:noreply, socket}
	end

	# def handle_out("new_msg", payload, socket) do
  #   push socket, "new_msg", payload
	# 	{:noreply, socket}
  # end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
