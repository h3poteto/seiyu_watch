defmodule SeiyuWatch.DiffParser do

  import Ecto.Query, only: [from: 2]
  alias SeiyuWatch.Repo
  alias SeiyuWatch.WikipediaResponse

  def parse_all_seiyus do
    SeiyuWatch.Seiyu
    |> Repo.all
    |> Enum.each(
    fn(s) ->
      Task.start(fn -> SeiyuWatch.DiffParser.update_diff(s.id, -7) end)
    end
    )
  end

  # days以上レコードが溜まっていない場合には，常にprev:即ち一回前との差分を取る
  def update_diff(seiyu_id, days) do
    time_from = Timex.shift(Timex.now, days: days)
    seiyu = SeiyuWatch.Seiyu
    |> Repo.get!(seiyu_id)
    |> Repo.preload(differences: (from a in SeiyuWatch.Difference, where: a.inserted_at < ^time_from, order_by: [desc: a.inserted_at]))

    wikipedia_page_request(seiyu)
    |> WikipediaResponse.get_response
    |> save(seiyu)
  end

  def current_revision(seiyu) do
    wikipedia_current_revision_request(seiyu.wiki_page_id)
    |> WikipediaResponse.get_response
    |> WikipediaResponse.revision_id
    |> elem(0)
  end

  def wikipedia_current_revision_request(wiki_page_id) do
    "https://ja.wikipedia.org/w/api.php?format=json&action=query&prop=revisions&pageids=#{wiki_page_id}&rvprop=sha1|ids"
  end

  # https://ja.wikipedia.org/w/api.php?format=json&action=query&prop=revisions&pageids=1543998&rvdiffto=61114635&rvprop=sha1|ids&rvstartid=61096294&rvendid=61096294
  # このように指定しないと，比較方向がおかしくなる
  # 現状difffromの指定はできないため，startidに旧idを設定し強制的にfromを実現する
  def wikipedia_page_request(seiyu) do
    case prev_revision(seiyu.differences) do
      0 ->
        "https://ja.wikipedia.org/w/api.php?format=json&action=query&prop=revisions&pageids=#{seiyu.wiki_page_id}&rvdiffto=prev&rvprop=sha1|ids"
      prev_rev ->
        "https://ja.wikipedia.org/w/api.php?format=json&action=query&prop=revisions&pageids=#{seiyu.wiki_page_id}&rvdiffto=#{current_revision(seiyu)}&rvprop=sha1|ids&rvstartid=#{prev_rev}&rvendid=#{prev_rev}"
    end
  end

  defp prev_revision(differences) do
    case differences |> Enum.count do
      0 -> 0
      _ -> (differences |> hd).to
    end
  end

  defp save(response, seiyu) do
    case WikipediaResponse.parse_diff(response) do
      {:ok, content, from, to} ->
        res = seiyu
        |> Ecto.build_assoc(:differences)
        |> SeiyuWatch.Difference.changeset(
          %{"wiki_diff" => content,
            "from" => from,
            "to" => to
          }
        )
        |> Repo.insert
        Task.start(fn -> SeiyuWatch.DifferenceEvent.after_update_diff(res) end)
        res
      error -> error
    end
  end
end
