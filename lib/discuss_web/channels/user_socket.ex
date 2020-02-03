defmodule DiscussWeb.UserSocket do
  use Phoenix.Socket

  # think of this as similar to a line in the router, something like:
  # get "/comments/:id", CommentsChannel, :join, :handle_in

  channel "comments:*", DiscussWeb.CommentsChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"token" => token}, socket, _connect_info) do
    case Phoenix.Token.verify(socket, "key", token) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}
      {:error, _error} ->
        :error
    end
    {:ok, socket}
  end

  def id(_socket), do: nil
end
