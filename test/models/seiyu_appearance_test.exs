defmodule SeiyuWatch.SeiyuAppearanceTest do
  use SeiyuWatch.ModelCase

  alias SeiyuWatch.SeiyuAppearance

  @valid_attrs %{revision: "some content", wiki_appearances: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SeiyuAppearance.changeset(%SeiyuAppearance{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SeiyuAppearance.changeset(%SeiyuAppearance{}, @invalid_attrs)
    refute changeset.valid?
  end
end
