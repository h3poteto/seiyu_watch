defmodule SeiyuWatch.DifferenceTest do
  use SeiyuWatch.ModelCase

  alias SeiyuWatch.Difference

  @valid_attrs %{wiki_diff: "some diff", from: 123456, to: 234567}
  @invalid_attrs %{}

  def seiyu(), do: Repo.insert! %SeiyuWatch.Seiyu{name: "阿澄佳奈"}

  def changeset(params) do
    seiyu()
    |> Ecto.build_assoc(:differences)
    |> Difference.changeset(params)
  end

  describe "validation" do
    test "changeset with valid attributes" do
      assert changeset(@valid_attrs).valid?
    end

    test "changeset with invalid attributes" do
      refute changeset(@invalid_attrs).valid?
    end
  end
end
