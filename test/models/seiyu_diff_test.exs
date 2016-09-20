defmodule SeiyuWatch.DifferenceTest do
  use SeiyuWatch.ModelCase

  alias SeiyuWatch.Difference

  @valid_attrs %{from: 42, to: 42, wiki_diff: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Difference.changeset(%Difference{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Difference.changeset(%Difference{}, @invalid_attrs)
    refute changeset.valid?
  end
end
