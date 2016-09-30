defmodule SeiyuWatch.WikipediaTest do
  use SeiyuWatch.ModelCase

  alias SeiyuWatch.Wikipedia

  @valid_attrs %{content: "some content"}
  @invalid_attrs %{}

  def seiyu(), do: Repo.insert! %SeiyuWatch.Seiyu{name: "阿澄佳奈"}

  def changeset(params) do
    seiyu()
      |> Ecto.build_assoc(:wikipedia)
      |> Wikipedia.changeset(params)
  end

  def wikipedia(params) do
    changeset(params)
    |> Repo.insert!
  end

  describe "validation" do
    test "changeset with valid attributes" do
      assert changeset(@valid_attrs).valid?
    end

    test "changeset with invalid attributes" do
      refute changeset(@invalid_attrs).valid?
    end
  end

  describe "#head" do
    test "wikipedia is nil" do
      assert Wikipedia.head(nil) == "No description"
    end

    test "wikipedia has 2 table and 2 p tags" do
      params = %{content: "<table class='table'><tr><td>hoge</td></tr></table><table class='table'><tr><td>hoge</td></tr></table><p>あすみかな</p><p>あすみん</p>"}
      assert wikipedia(params) |> Wikipedia.head == "<p>あすみかな</p><p>あすみん</p>"
    end

    test "wikipedia has no p tags" do
      params = %{content: "<table class='table'><tr><td>hoge</td></tr></table><table class='table'><tr><td>hoge</td></tr></table><b>あすみかな</b><b>あすみん</b>"}
      assert wikipedia(params) |> Wikipedia.head == ""
    end
  end
end
