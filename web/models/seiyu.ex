defmodule SeiyuWatch.Seiyu do
  use SeiyuWatch.Web, :model

  schema "seiyus" do
    field :name, :string
    field :wiki_page_id, :integer
    field :appearances_updated_at, Ecto.DateTime
    has_many :seiyu_appearance, SeiyuWatch.SeiyuAppearance

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :wiki_page_id, :appearances_updated_at])
    |> validate_required([:name, :wiki_page_id])
  end

end
