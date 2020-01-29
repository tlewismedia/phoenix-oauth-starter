defmodule DiscussWeb.TopicController do
  alias Discuss.Repo
  use DiscussWeb, :controller

  alias Discuss.Topic

  def index(conn, _params) do
    IO.inspect(conn.assigns)
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def new(conn, _params ) do
    struct = %Topic{}
    params = %{}
    changeset = Topic.changeset(struct, params)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic

  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get( Topic, topic_id )
    changeset = Topic.changeset( old_topic, topic )

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Update")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end
  end

  def delete(conn, %{"id" => topic_id} ) do
    topic = Repo.get!(Topic, topic_id) |> Repo.delete!

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: Routes.topic_path(conn, :index))

    # case Repo.delete(topic_id) do
    #   {:ok, _topic} ->
    #     conn
    #     |> put_flash(:info, "Topic Deleted")
    #     |> redirect(to: Routes.topic_path(conn, :index))
    #   {:error, changeset} ->
    #     render conn, "edit.html", changeset: changeset, topic: old_topic
    # end
  end
end
