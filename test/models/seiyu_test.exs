defmodule SeiyuWatch.SeiyuTest do
  use SeiyuWatch.ModelCase

  alias SeiyuWatch.Seiyu

  @valid_attrs %{name: "阿澄佳奈", wiki_page_id: 123456, wiki_url: "http://example.com"}
  @invalid_attrs %{}

  describe "validation" do
    test "changeset with valid attributes" do
      changeset = Seiyu.changeset(%Seiyu{}, @valid_attrs)
      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = Seiyu.changeset(%Seiyu{}, @invalid_attrs)
      refute changeset.valid?
    end
  end
end
