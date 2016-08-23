defmodule SeiyuWatch.SeiyuParser do

  defmacro __using__(_opts) do
    quote do
      require SeiyuWatch.Seiyu
      require SeiyuWatch.WikipediaResponse
    end
  end

  alias SeiyuWatch.Repo
  alias SeiyuWatch.WikipediaResponse

  def save(name) do
    # 声優であることの確認をする
    if wikipedia_category_request(name)
    |> WikipediaResponse.get_response
    |> WikipediaResponse.parse_categories
    |> WikipediaResponse.find_seiyu_category do
      # wikitextであることの確認をする
      if wikipedia_page_request(name)
      |> WikipediaResponse.get_response
      |> WikipediaResponse.is_wikitext do
        SeiyuWatch.Seiyu.changeset(%SeiyuWatch.Seiyu{}, %{"name" => name})
        |> Repo.insert
      else
        {:failed, name}
      end
    else
      {:failed, name}
    end
  end

  defp wikipedia_category_request(name) do
    "https://ja.wikipedia.org/w/api.php?format=json&action=query&prop=categories&titles=#{URI.encode(name)}"
  end

  defp wikipedia_page_request(name) do
    # contetnmodel == wikitextのもであればparsetree指定でxml parseされたものが帰る
    "https://ja.wikipedia.org/w/api.php?format=json&action=query&prop=revisions&titles=#{URI.encode(name)}&rvprop=parsetree|contentmodel"
  end
end
