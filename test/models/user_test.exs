defmodule Hotchpotch.UserTest do
  use Hotchpotch.ModelCase

  alias Hotchpotch.User

  @valid_attrs %{email: "fake@example.com", password: "some content", nickname: "大傻", username: "fakename"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "nickname should not be blank" do
    attrs = %{@valid_attrs | nickname: ""}
    assert {:nickname, "请填写"} in errors_on(%User{}, attrs)
  end

  test "nickname should be unique" do
    user_changeset = User.changeset(%User{}, @valid_attrs)
    Hotchpotch.Repo.insert! user_changeset

    assert {:error, changeset} = Hotchpotch.Repo.insert(User.changeset(%User{}, %{@valid_attrs | email: "fake1@example.com", username: "fakename1"}))
    assert {:nickname, "昵称已被占用"} in errors_on(changeset)
  end

  test "nickname's length should be larger than 2" do
    attrs = %{@valid_attrs | nickname: "啊"}
    changeset = User.changeset(%User{}, attrs)
    assert {:nickname, "昵称最短 2 位"} in errors_on(changeset)
  end

  test "nickname's length should be less than 9" do
    attrs = %{@valid_attrs | nickname: String.duplicate("艹", 10)}
    changeset = User.changeset(%User{}, attrs)
    assert {:nickname, "昵称最长 9 位"} in errors_on(changeset)
  end

  test "username should be unique" do
    user_changeset = User.changeset(%User{}, @valid_attrs)
    Hotchpotch.Repo.insert! user_changeset

    assert {:error, changeset} = Hotchpotch.Repo.insert(User.changeset(%User{}, %{@valid_attrs | email: "fake1@example.com", nickname: "二傻"}))
    assert {:username, "用户名已被占用"} in errors_on(changeset)
  end

  test "username should be case insensitive" do
    user_changeset = User.changeset(%User{}, @valid_attrs)
    Hotchpotch.Repo.insert! user_changeset

    another_user_changeset = User.changeset(%User{}, %{@valid_attrs | username: "FakeName", email: "fake1@example.com", nickname: "二傻"})
    assert {:error, changeset} = Hotchpotch.Repo.insert(another_user_changeset)
    assert {:username, "用户名已被占用"} in errors_on(changeset)
  end

  test "username should only contains [a-zA-Z0-9_]" do
    attrs = %{@valid_attrs | username: "陈三"}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?
  end

  test "changeset with invalid username should throw errors" do
    attrs = %{@valid_attrs | username: "陈三"}
    assert {:username, "用户名只允许使用英文字母、数字及下划线"} in errors_on(%User{}, attrs)
  end

  test "username's length should be larger than 4" do
    attrs = %{@valid_attrs | username: "ab"}
    changeset = User.changeset(%User{}, attrs)
    assert {:username, "用户名最短 4 位"} in errors_on(changeset)
  end

  test "username's length should be less than 15" do
    attrs = %{@valid_attrs | username: String.duplicate("a", 16)}
    changeset = User.changeset(%User{}, attrs)
    assert {:username, "用户名最长 15 位"} in errors_on(changeset)
  end

  test "username should not be admin or administrator" do
    assert {:username, "系统保留，无法注册，请更换"} in errors_on(%User{}, %{@valid_attrs | username: "root"})
    assert {:username, "系统保留，无法注册，请更换"} in errors_on(%User{}, %{@valid_attrs | username: "admin"})
    assert {:username, "系统保留，无法注册，请更换"} in errors_on(%User{}, %{@valid_attrs | username: "administrator"})
  end


  test "email should not be blank" do
    attrs = %{@valid_attrs | email: ""}
    assert {:email, "请填写"} in errors_on(%User{}, attrs)
  end

  test "email should contain @" do
    attrs = %{@valid_attrs | email: "ab"}
    assert {:email, "邮箱格式错误"} in errors_on(%User{}, attrs)
  end

  test "email should be unique" do
    user_changeset = User.changeset(%User{}, @valid_attrs)
    Hotchpotch.Repo.insert! user_changeset
    assert {:error, changeset} = Hotchpotch.Repo.insert(User.changeset(%User{}, %{@valid_attrs | username: "fakename1", nickname: "二傻"}))
    assert {:email, "邮箱已被占用"} in errors_on(changeset)
  end

  # test "email should be case insensitive" do
  #   user_changeset = User.changeset(%User{}, @valid_attrs)
  #   Hotchpotch.Repo.insert! user_changeset

  #   # 尝试插入大小写不一致的邮箱，应报告错误
  #   another_user_changeset = User.changeset(%User{}, %{@valid_attrs | username: "samchen", email: "Fake@example.com"})
  #   assert {:error, changeset} = Hotchpotch.Repo.insert(another_user_changeset)
  #   assert {:email, "邮箱已被占用"} in errors_on(changeset)
  # end

  test "password is required" do
    attrs = %{@valid_attrs | password: ""}
    assert {:password, "请填写"} in errors_on(%User{}, attrs)
  end

  test "password's length should be larger than 6" do
    attrs = %{@valid_attrs | password: String.duplicate("1", 5)}
    assert {:password, "密码最短 6 位"} in errors_on(%User{}, attrs)
  end

  test "password should be hashed" do
    %{changes: changes} = User.changeset(%User{}, @valid_attrs)
    assert Comeonin.Bcrypt.checkpw(changes.password, changes.password_hash)
  end
end
