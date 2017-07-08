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
    |> cast(params, [:title, :user_id])
    |> validate_required([:title, :user_id], message: "请填写")
    |> foreign_key_constraint(:user_id, message: "用户不存在")
  end
end
