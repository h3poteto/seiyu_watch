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
    response = wikipedia_page_request(name) |> WikipediaResponse.get_response
    if response
    |> WikipediaResponse.parse_categories
    |> WikipediaResponse.find_seiyu_category do
      SeiyuWatch.Seiyu.changeset(%SeiyuWatch.Seiyu{}, %{"name" => name, "wiki_page_id" => WikipediaResponse.page_id(response)})
      |> Repo.insert
    else
      {:failed, name}
    end
  end

  defp wikipedia_page_request(name) do
    "https://ja.wikipedia.org/w/api.php?format=json&action=query&prop=revisions|categories&titles=#{URI.encode(name)}&rvprop=sha1|ids"
  end
end
