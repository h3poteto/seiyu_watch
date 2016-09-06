defmodule SeiyuWatch.AppearancesDiffTest do
  use SeiyuWatch.ModelCase

  alias SeiyuWatch.AppearancesDiff

  @valid_attrs %{add_html: "some content", sub_html: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AppearancesDiff.changeset(%AppearancesDiff{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AppearancesDiff.changeset(%AppearancesDiff{}, @invalid_attrs)
    refute changeset.valid?
  end
end
