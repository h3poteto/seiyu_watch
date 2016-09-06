defmodule SeiyuWatch.AppearancesParser do

  import Ecto.Query, only: [from: 2]
  alias SeiyuWatch.Repo
  alias SeiyuWatch.WikipediaResponse

  def check_and_save(seiyu_id) do
    seiyu = SeiyuWatch.Seiyu
    |> Repo.get!(seiyu_id)
    |> Repo.preload(seiyu_appearances: (from a in SeiyuWatch.SeiyuAppearance, order_by: [desc: a.inserted_at]))

    response = wikipedia_page_request(seiyu.wiki_page_id) |> WikipediaResponse.get_response
    cond do
      seiyu.seiyu_appearances |> Enum.count == 0 ->
        # 問答無用で保存する
        save(response, seiyu_id)
      (seiyu.seiyu_appearances |> hd).revision != WikipediaResponse.revision_id(response) |> elem(1) ->
        # 差分があるということなのでチェックして保存する
        add(response, seiyu)
      true -> {:ok, :unchanged}
    end

  end

  defp save(response, seiyu_id) do
    res = SeiyuWatch.SeiyuAppearance.changeset(
      %SeiyuWatch.SeiyuAppearance{},
      %{"seiyu_id" => seiyu_id,
        "revision" => WikipediaResponse.revision_id(response) |> elem(1),
        "revision_id" => WikipediaResponse.revision_id(response) |> elem(0),
        "wiki_appearances" => WikipediaResponse.appearances(response) |> WikipediaResponse.to_html
      }
    )
    |> Repo.insert
    Task.start_link(fn -> SeiyuWatch.SeiyuAppearanceEvent.after_update_appearance(res) end)
  end

  def add(response, seiyu) do
    if WikipediaResponse.appearances(response) |> WikipediaResponse.to_html != (seiyu.seiyu_appearances |> hd).wiki_appearances do
      save(response, seiyu.id)
    end
  end

  defp wikipedia_page_request(wiki_page_id) do
    "https://ja.wikipedia.org/w/api.php?format=json&action=query&prop=revisions&pageids=#{wiki_page_id}&rvprop=content|sha1|ids&rvparse"
  end
end
