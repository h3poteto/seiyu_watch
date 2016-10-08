defmodule SeiyuWatch.WikiParser do
  alias SeiyuWatch.Repo
  alias SeiyuWatch.WikipediaResponse

  def update_wiki(seiyu_id) do
    seiyu = SeiyuWatch.Seiyu
    |> Repo.get!(seiyu_id)
    |> Repo.preload(:wikipedia)

    content = wikipedia_page_request(seiyu.wiki_page_id)
    |> WikipediaResponse.get_response
    |> WikipediaResponse.parse_content

    case seiyu.wikipedia do
      nil ->
        seiyu
        |> Ecto.build_assoc(:wikipedia)
        |> SeiyuWatch.Wikipedia.changeset(
          %{
            "content" => content
          }
        )
        |> Repo.insert
      wiki ->
        Ecto.Changeset.change(wiki, content: content)
        |> Repo.update
    end
  end

  def wikipedia_page_request(wiki_page_id) do
    "https://ja.wikipedia.org/w/api.php?format=json&action=query&prop=revisions&pageids=#{wiki_page_id}&rvprop=content|sha1|ids&rvparse"
  end
end
