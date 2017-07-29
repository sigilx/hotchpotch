defmodule HotchpotchWeb.Board do
  use HotchpotchWeb, :model

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
    |> validate_required([:title], message: "请填写")
    |> validate_length(:title, min: 4, message: "标题最短 4 位")
    |> validate_length(:title, max: 20, message: "标题最长 20 位")
    |> unique_constraint(:user_id)
    |> foreign_key_constraint(:user_id)
  end
end
