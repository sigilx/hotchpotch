defmodule HotchpotchWeb.BoardChannel do
  use HotchpotchWeb, :channel

  alias Hotchpotch.Repo
  alias HotchpotchWeb.Board

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

  def handle_in("new_msg", %{"name" => name, "body" => body, "is_system" => is_system}, socket) do
    broadcast! socket, "new_msg", %{name: name, body: body, is_system: is_system}
    {:noreply, socket}
  end

  # def handle_out("new_msg", payload, socket) do
  #   push socket, "new_msg", payload
  #   {:noreply, socket}
  # end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (board:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
