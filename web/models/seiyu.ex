defmodule SeiyuWatch.Seiyu do
  use SeiyuWatch.Web, :model
  alias SeiyuWatch.Repo
  import Ecto.Query, only: [from: 2]

  schema "seiyus" do
    field :name, :string
    field :wiki_page_id, :integer
    field :appearances_updated_at, Ecto.DateTime
    has_many :seiyu_appearances, SeiyuWatch.SeiyuAppearance

    timestamps
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :wiki_page_id, :appearances_updated_at])
    |> validate_required([:name, :wiki_page_id])
  end

  def update_appearance(seiyu_id) do
    SeiyuWatch.Seiyu
    |> Repo.get!(seiyu_id)
    |> changeset(%{"appearances_updated_at" => Timex.now})
    |> Repo.update
  end

  def appearances_diff(seiyu, days) do
    case previous_appearance(seiyu, days) do
      {:ok, previous} ->
        case current_appearance(seiyu, days) do
          {:ok, current} -> compare_appearances(current, previous)
          {:error, :no_content} -> {:error, "", ""}
        end
      {:error, :no_content} -> {:error, "", ""}
    end
  end

  defp compare_appearances(new_appearance, old_appearance) do
    new_app = new_appearance.wiki_appearances |> Floki.parse
    old_app = old_appearance.wiki_appearances |> Floki.parse
    add_diff = new_app -- old_app |> Floki.raw_html
    sub_diff = old_app -- new_app |> Floki.raw_html
    {:ok, add_diff, sub_diff}
  end

  def previous_appearance(seiyu, days) do
    time_from = Timex.shift(Timex.now, days: days)
    case (seiyu
    |> Repo.preload(seiyu_appearances: (from a in SeiyuWatch.SeiyuAppearance, where: a.inserted_at < ^time_from, order_by: [desc: a.inserted_at]))
    ).seiyu_appearances
    |> Enum.at(0) do
      nil -> {:error, :no_content}
      value -> {:ok, value}
    end
  end

  def current_appearance(seiyu, days) do
    time_from = Timex.shift(Timex.now, days: days)
    case (seiyu
    |> Repo.preload(seiyu_appearances: (from a in SeiyuWatch.SeiyuAppearance, where: a.inserted_at >= ^time_from, order_by: [desc: a.inserted_at]))
    ).seiyu_appearances
    |> Enum.at(0) do
      nil -> {:error, :no_content}
      value -> {:ok, value}
    end
  end
end
