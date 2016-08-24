defmodule SeiyuWatch.AppearancesParser do

  defmacro __using__(_opts) do
    quote do
      require SeiyuWatch.Seiyu
      require SeiyuWatch.WikipediaResponse
    end
  end

  alias SeiyuWatch.Repo
  alias SeiyuWatch.WikipediaResponse

  def check_and_update(seiyu_id) do
    seiyu = Repo.get!(Seiyu, seiyu_id)
    response = wikipedia_page_request(seiyu.name) |> WikipediaResponse.get_response
  end

  defp wikipedia_page_request(wiki_page_id) do
    "https://ja.wikipedia.org/w/api.php?format=json&action=query&prop=revisions&pageids=#{wiki_page_id}&rvprop=parsetree|contentmodel|sha1|ids"
  end

end
