defmodule Hotchpotch.Board do
  use Hotchpotch.Web, :model

  schema "boards" do
    field :title, :string
    belongs_to :user, Hotchpotch.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
