defmodule SeiyuWatch.Seiyu do
  use SeiyuWatch.Web, :model
  alias SeiyuWatch.Repo
  import Ecto.Query, only: [from: 2]

  schema "seiyus" do
    field :name, :string
    field :wiki_page_id, :integer
    field :diffs_updated_at, Ecto.DateTime
    field :wiki_url, :string
    has_many :differences, SeiyuWatch.Difference
    has_one :wikipedia, SeiyuWatch.Wikipedia

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :wiki_page_id, :diffs_updated_at, :wiki_url])
    |> validate_required([:name, :wiki_page_id, :wiki_url])
  end

  def update_diff_timestamp(seiyu_id) do
    SeiyuWatch.Seiyu
    |> Repo.get!(seiyu_id)
    |> changeset(%{"diffs_updated_at" => Timex.now})
    |> Repo.update
  end

  def recent_diff(seiyu) do
    case (seiyu
    |> Repo.preload(differences: (from a in SeiyuWatch.Difference, order_by: [desc: a.inserted_at]))
    ).differences
    |> Enum.at(0) do
      nil -> {:error, ""}
      value -> {:ok, value.wiki_diff}
    end
  end

end
