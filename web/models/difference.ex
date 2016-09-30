defmodule SeiyuWatch.Difference do
  use SeiyuWatch.Web, :model

  schema "differences" do
    field :wiki_diff, :string
    field :from, :integer
    field :to, :integer
    belongs_to :seiyu, SeiyuWatch.Seiyu

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  # TODO: belongs_toはseiyu_idをパラメータで渡すのやめたい
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:wiki_diff, :from, :to, :seiyu_id])
    |> assoc_constraint(:seiyu)
    |> validate_required([:wiki_diff, :from, :to, :seiyu_id])
  end
end
