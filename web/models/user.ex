defmodule Hotchpotch.User do
  use Hotchpotch.Web, :model

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email, :password])
    |> validate_required([:username, :email, :password], message: "请填写")
    |> validate_format(:username, ~r/^[a-zA-Z0-9_]+$/, message: "用户名只允许使用英文字母、数字及下划线")
    |> validate_length(:username, min: 4, message: "用户名最短 4 位")
    |> validate_length(:username, max: 15, message: "用户名最长 15 位")
    |> validate_exclusion(:username, ~w(root admin administrator), message: "系统保留，无法注册，请更换")
    |> unique_constraint(:username, name: :users_lower_username_index, message: "用户名已被占用")
    |> validate_format(:email, ~r/@/, message: "邮箱格式错误")
    |> unique_constraint(:email, name: :users_lower_email_index, message: "邮箱已被占用")
    |> validate_length(:password, min: 6, message: "密码最短 6 位")
  end
end
