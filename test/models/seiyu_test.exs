defmodule SeiyuWatch.SeiyuTest do
  use SeiyuWatch.ModelCase

  alias SeiyuWatch.Seiyu

  @valid_attrs %{name: "some content", wiki_url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Seiyu.changeset(%Seiyu{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Seiyu.changeset(%Seiyu{}, @invalid_attrs)
    refute changeset.valid?
  end
end
