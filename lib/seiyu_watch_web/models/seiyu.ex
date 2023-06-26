defmodule SeiyuWatch.Seiyu do
  use SeiyuWatchWeb, :model
  use Arc.Ecto.Schema
  alias SeiyuWatch.Repo
  import Ecto.Query, only: [from: 2, order_by: 2, preload: 2]

  schema "seiyus" do
    field(:name, :string)
    field(:icon, SeiyuWatch.Icon.Type)
    field(:wiki_page_id, :integer)
    field(:diffs_updated_at, :naive_datetime)
    field(:wiki_url, :string)
    has_many(:differences, SeiyuWatch.Difference)
    has_one(:wikipedia, SeiyuWatch.Wikipedia)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :wiki_page_id, :diffs_updated_at, :wiki_url])
    |> cast_attachments(params, [:icon])
    |> validate_required([:name, :wiki_page_id, :wiki_url])
  end

  def update_diff_timestamp(seiyu_id) do
    SeiyuWatch.Seiyu
    |> Repo.get!(seiyu_id)
    |> changeset(%{"diffs_updated_at" => Timex.now()})
    |> Repo.update()
  end

  def recent_diff(seiyu) do
    case (seiyu
          |> Repo.preload(
            differences: from(a in SeiyuWatch.Difference, order_by: [desc: a.inserted_at])
          )).differences
         |> Enum.at(0) do
      nil -> {:error, ""}
      value -> {:ok, value.wiki_diff}
    end
  end

  def seiyus(params) do
    SeiyuWatch.Seiyu
    |> seiyus_query(params)
  end

  def seiyus(%{"query" => query}, params) do
    SeiyuWatch.Seiyu
    |> search_query(query)
    |> seiyus_query(params)
  end

  defp search_query(source, query) do
    q = "%#{query}%"

    from(s in source,
      where: like(s.name, ^q)
    )
  end

  defp seiyus_query(source, params) do
    source
    |> order_by(desc: :diffs_updated_at)
    |> preload(:wikipedia)
    |> Repo.paginate(params)
  end
end
