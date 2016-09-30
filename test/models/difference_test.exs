defmodule SeiyuWatch.DifferenceTest do
  use SeiyuWatch.ModelCase

  alias SeiyuWatch.Difference

  @valid_attrs %{wiki_diff: "some diff", from: 123456, to: 234567, seiyu_id: 1}
  @invalid_attrs %{}

  describe "validation" do
    test "changeset with valid attributes" do
      changeset = Difference.changeset(%Difference{}, @valid_attrs)
      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = Difference.changeset(%Difference{}, @invalid_attrs)
      refute changeset.valid?
    end
  end
end
