defmodule SeiyuWatch.DiffParser do

  import Ecto.Query, only: [from: 2]
  alias SeiyuWatch.Repo
  alias SeiyuWatch.WikipediaResponse

  def parse_all_seiyus do
    SeiyuWatch.Seiyu
    |> Repo.all
    |> Enum.each(
    fn(s) ->
      update_diff(s.id, -7)
    end
    )
  end

  # days以上レコードが溜まっていない場合には，常にprev:即ち一回前との差分を取る
  def update_diff(seiyu_id, days) do
    time_from = Timex.shift(Timex.now, days: days)
    seiyu = SeiyuWatch.Seiyu
    |> Repo.get!(seiyu_id)
    |> Repo.preload(seiyu_diffs: (from a in SeiyuWatch.SeiyuDiff, where: a.inserted_at < ^time_from, order_by: [desc: a.inserted_at]))

    wikipedia_page_request(seiyu.wiki_page_id, prev_revision(seiyu.seiyu_diffs))
    |> WikipediaResponse.get_response
    |> save(seiyu.id)
  end

  def wikipedia_page_request(wiki_page_id, prev_rev \\ "prev") do
    "https://ja.wikipedia.org/w/api.php?format=json&action=query&prop=revisions&pageids=#{wiki_page_id}&rvdiffto=#{prev_rev}&rvprop=sha1|ids"
  end

  defp prev_revision(seiyu_diffs) do
    case seiyu_diffs |> Enum.count do
      0 -> "prev"
      _ -> (seiyu_diffs |> hd).revision_id
    end
  end

  defp save(response, seiyu_id) do
    case WikipediaResponse.parse_diff(response) do
      {:ok, content, from, to} ->
        res = SeiyuWatch.SeiyuDiff.changeset(
        %SeiyuWatch.SeiyuDiff{},
        %{"seiyu_id" => seiyu_id,
          "revision_hash" => WikipediaResponse.revision_id(response) |> elem(1),
          "revision_id" => WikipediaResponse.revision_id(response) |> elem(0),
          "wiki_diff" => content,
          "from" => from,
          "to" => to
        }
      )
      |> Repo.insert
        Task.start_link(fn -> SeiyuWatch.SeiyuDiffEvent.after_update_diff(res) end)
      error -> error
    end
  end
end
