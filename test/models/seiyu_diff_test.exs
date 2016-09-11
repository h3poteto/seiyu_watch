defmodule SeiyuWatch.SeiyuDiffTest do
  use SeiyuWatch.ModelCase

  alias SeiyuWatch.SeiyuDiff

  @valid_attrs %{from: 42, revision_hash: "some content", revision_id: 42, to: 42, wiki_diff: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SeiyuDiff.changeset(%SeiyuDiff{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SeiyuDiff.changeset(%SeiyuDiff{}, @invalid_attrs)
    refute changeset.valid?
  end
end
