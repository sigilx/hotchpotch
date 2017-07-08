defmodule Hotchpotch.BoardTest do
  use Hotchpotch.ModelCase

  alias Hotchpotch.Board

  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Board.changeset(%Board{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Board.changeset(%Board{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "title is required" do
    attrs = %{@valid_attrs | title: ""}
    assert {:title, "请填写"} in errors_on(%Board{}, attrs)
  end

  test "title's length should be larger than 4" do
    attrs = %{@valid_attrs | title: "abc"}
    changeset = Board.changeset(%Board{}, attrs)
    assert {:title, "标题最短 4 位"} in errors_on(changeset)
  end

  test "title's length should be less than 20" do
    attrs = %{@valid_attrs | title: String.duplicate("a", 21)}
    changeset = Board.changeset(%Board{}, attrs)
    assert {:title, "标题最长 20 位"} in errors_on(changeset)
  end

end
