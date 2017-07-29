defmodule HotchpotchWeb.User do
  use HotchpotchWeb, :model

  schema "users" do
    field :username, :string
    field :nickname, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_one :board, HotchpotchWeb.Board

    timestamps()
  end

  @required_fields ~w(nickname email password)a
  @allowed_fields ~w(username nickname email password)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields, message: "请填写")
    |> validate_length(:nickname, min: 2, message: "昵称最短 2 位")
    |> validate_length(:nickname, max: 9, message: "昵称最长 9 位")
    |> unique_constraint(:nickname, message: "昵称已被占用")
    |> validate_format(:username, ~r/^[a-zA-Z0-9_]+$/, message: "用户名只允许使用英文字母、数字及下划线")
    |> validate_length(:username, min: 4, message: "用户名最短 4 位")
    |> validate_length(:username, max: 15, message: "用户名最长 15 位")
    |> validate_exclusion(:username, ~w(root admin administrator), message: "系统保留，无法注册，请更换")
    |> unique_constraint(:username, name: :users_lower_username_index, message: "用户名已被占用")
    |> validate_format(:email, ~r/@/, message: "邮箱格式错误")
    |> unique_constraint(:email, message: "邮箱已被占用")
    |> validate_length(:password, min: 6, message: "密码最短 6 位")
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
