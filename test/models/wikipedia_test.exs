defmodule SeiyuWatch.WikipediaTest do
  use SeiyuWatch.ModelCase

  alias SeiyuWatch.Wikipedia

  @valid_attrs %{content: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Wikipedia.changeset(%Wikipedia{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Wikipedia.changeset(%Wikipedia{}, @invalid_attrs)
    refute changeset.valid?
  end
end
