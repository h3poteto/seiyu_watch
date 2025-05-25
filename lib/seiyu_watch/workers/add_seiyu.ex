defmodule SeiyuWatch.Workers.AddSeiyu do
  use Oban.Worker, queue: :default, max_attempts: 3
  alias SeiyuWatch.Repo
  alias SeiyuWatch.WikipediaResponse

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"name" => name}}) do
    save(name)

    :ok
  end

  def save(name) do
    # 声優であることの確認をする
    response = wikipedia_page_request(name) |> WikipediaResponse.get_response()

    if response
       |> WikipediaResponse.parse_categories()
       |> WikipediaResponse.find_seiyu_category() do
      create =
        SeiyuWatch.Seiyu.changeset(%SeiyuWatch.Seiyu{}, %{
          "name" => name,
          "wiki_page_id" => WikipediaResponse.page_id(response),
          "wiki_url" => WikipediaResponse.url(response)
        })
        |> Repo.insert!()

      %{"seiyu_id" => create.id}
      |> SeiyuWatch.Workers.ImageSearcher.new()
      |> Oban.insert()

      create
    else
      {:failed, name}
    end
  end

  def wikipedia_page_request(name) do
    "https://ja.wikipedia.org/w/api.php?format=json&action=query&prop=revisions|categories|info&titles=#{URI.encode(name)}&rvprop=sha1|ids&inprop=url&cllimit=500"
  end
end
