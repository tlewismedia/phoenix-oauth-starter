defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel

  alias Discuss.{Topic, Repo, Comment}

  def join("comments:" <> topic_id, _params, socket) do
      topic_id = String.to_integer(topic_id)

      topic =
        Topic
        |> Repo.get( topic_id )
        |> Repo.preload(comments: [:user])

    # IO.puts('DEBUG -------------------')
    # IO.puts('comments_channel:join')
    # todo: test - topic should have user_id:')
    # IO.puts('topic should have user_id:')
    # IO.inspect(topic)

      {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in(name, %{"content" => content}, socket) do
    IO.puts('DEBUG -------------------')
    IO.puts('comments_channel:handle_in')

    topic = socket.assigns.topic

    IO.puts('socket.assigns:')
    IO.inspect(socket.assigns)


    user_id = topic.user_id

    changeset = topic
      |> Ecto.build_assoc(:comments, user_id: user_id)
      |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast!(
          socket,
          "comments:#{socket.assigns.topic.id}:new",
          %{comment: Repo.preload(comment, :user)}
        )
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket }
    end

    {:reply, :ok, socket}
  end
end

