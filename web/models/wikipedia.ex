defmodule SeiyuWatch.Wikipedia do
  use SeiyuWatch.Web, :model

  schema "wikipedias" do
    field :content, :string
    belongs_to :seiyu, SeiyuWatch.Seiyu

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :seiyu_id])
    |> assoc_constraint(:seiyu)
    |> validate_required([:content, :seiyu_id])
  end
end
