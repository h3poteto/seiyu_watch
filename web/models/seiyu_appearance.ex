defmodule SeiyuWatch.SeiyuAppearance do
  use SeiyuWatch.Web, :model

  schema "seiyu_appearances" do
    field :wiki_appearances, :string
    field :revision, :string
    field :revision_id, :integer
    belongs_to :seiyu, SeiyuWatch.Seiyu

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:wiki_appearances, :revision, :revision_id, :seiyu_id])
    |> assoc_constraint(:seiyu)
    |> validate_required([:wiki_appearances, :revision, :revision_id, :seiyu_id])
  end
end
