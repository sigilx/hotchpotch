defmodule Hotchpotch.Boards.Board do
  use Ecto.Schema
  import Ecto.Changeset
  alias Hotchpotch.Boards.Board


  schema "boards" do
    field :title, :string
    belongs_to :user, Hotchpotch.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Board{} = board, attrs) do
    board
    |> cast(attrs, [:title])
    |> validate_required([:title], message: "请填写")
    |> validate_length(:title, min: 4, message: "标题最短 4 位")
    |> validate_length(:title, max: 20, message: "标题最长 20 位")
    |> unique_constraint(:user_id)
    |> foreign_key_constraint(:user_id)
  end
end
