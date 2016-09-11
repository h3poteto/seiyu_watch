defmodule SeiyuWatch.Seiyu do
  use SeiyuWatch.Web, :model
  alias SeiyuWatch.Repo
  import Ecto.Query, only: [from: 2]

  schema "seiyus" do
    field :name, :string
    field :wiki_page_id, :integer
    field :diffs_updated_at, Ecto.DateTime
    has_many :seiyu_diffs, SeiyuWatch.SeiyuDiff

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :wiki_page_id, :diffs_updated_at])
    |> validate_required([:name, :wiki_page_id])
  end

  def update_diff_timestamp(seiyu_id) do
    SeiyuWatch.Seiyu
    |> Repo.get!(seiyu_id)
    |> changeset(%{"diffs_updated_at" => Timex.now})
    |> Repo.update
  end

  def recent_diff(seiyu) do
    case (seiyu
    |> Repo.preload(seiyu_diffs: (from a in SeiyuWatch.SeiyuDiff, order_by: [desc: a.inserted_at]))
    ).seiyu_diffs
    |> Enum.at(0) do
      nil -> {:error, ""}
      value -> {:ok, value.wiki_diff}
    end
  end

end
