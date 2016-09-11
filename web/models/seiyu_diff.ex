defmodule SeiyuWatch.SeiyuDiff do
  use SeiyuWatch.Web, :model

  schema "seiyu_diffs" do
    field :wiki_diff, :string
    field :revision_hash, :string
    field :revision_id, :integer
    field :from, :integer
    field :to, :integer
    belongs_to :seiyu, SeiyuWatch.Seiyu

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:wiki_diff, :revision_hash, :revision_id, :from, :to, :seiyu_id])
    |> assoc_constraint(:seiyu)
    |> validate_required([:wiki_diff, :revision_hash, :revision_id, :from, :to, :seiyu_id])
  end
end
