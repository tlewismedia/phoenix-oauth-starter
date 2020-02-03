defmodule Discuss.Comment do
  import Ecto.Changeset
  use Ecto.Schema

  @derive {Jason.Encoder, only: [:content, :inserted_at, :user]}

  schema "comments" do
    field :content, :string
    belongs_to :user, Discuss.User
    belongs_to :topic, Discuss.Topic


    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content])
    |> validate_required([:content])
  end
end
