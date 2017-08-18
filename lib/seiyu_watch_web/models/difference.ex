defmodule SeiyuWatch.Difference do
  use SeiyuWatchWeb, :model

  schema "differences" do
    field :wiki_diff, :string
    field :from, :integer
    field :to, :integer
    belongs_to :seiyu, SeiyuWatch.Seiyu

    timestamps()
  end

  @required_fields ~w(wiki_diff from to seiyu_id)
  @optional_fields ~w()

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> assoc_constraint(:seiyu)
    |> unique_constraint(:to, name: :differences_to_from_index)
  end
end
