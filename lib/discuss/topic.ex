defmodule Discuss.Topic do
  import Ecto.Changeset
  use Ecto.Schema

  schema "topics" do
    field :title, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end

end
