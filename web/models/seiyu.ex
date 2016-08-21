defmodule SeiyuWatch.Seiyu do
  use SeiyuWatch.Web, :model

  schema "seiyus" do
    field :name, :string
    field :wiki_url, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :wiki_url])
    |> validate_required([:name, :wiki_url])
  end
end
