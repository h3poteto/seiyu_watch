defmodule SeiyuWatch.Workers.WikiParser do
  use Oban.Worker, queue: :default, max_attempts: 3
  alias SeiyuWatch.Repo
  alias SeiyuWatch.WikipediaResponse

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"seiyu_id" => seiyu_id}}) do
    seiyu =
      SeiyuWatch.Seiyu
      |> Repo.get!(seiyu_id)
      |> Repo.preload(:wikipedia)

    content =
      wikipedia_page_request(seiyu.wiki_page_id)
      |> WikipediaResponse.get_response()
      |> WikipediaResponse.parse_content()

    case seiyu.wikipedia do
      nil ->
        seiyu
        |> Ecto.build_assoc(:wikipedia)
        |> SeiyuWatch.Wikipedia.changeset(%{
          "content" => content
        })
        |> Repo.insert!()

      wiki ->
        Ecto.Changeset.change(wiki, content: content)
        |> Repo.update!()
    end

    :ok
  end

  def wikipedia_page_request(wiki_page_id) do
    "https://ja.wikipedia.org/w/api.php?format=json&action=query&prop=revisions&pageids=#{wiki_page_id}&rvprop=content|sha1|ids&rvparse"
  end
end

defmodule SeiyuWatch.WikipediaResponse do
  def get_response(request) do
    url = request
    options = [:timeout, 60000, :recv_timeout, 60000]
    result = HTTPoison.get!(url, [], options)

    case result do
      %{status_code: 200, body: body} -> Poison.decode!(body)
      %{status_code: _code} -> nil
    end
  end

  def parse_categories(response) do
    query(response) |> pages |> single_page |> categories
  end

  def find_seiyu_category(categories) do
    Enum.any?(categories, fn
      %{"ns" => _num, "title" => category} -> category == "Category:日本の女性声優"
    end) ||
      Enum.any?(categories, fn
        %{"ns" => _num, "title" => category} -> category == "Category:日本の男性声優"
      end)
  end

  def page_id(response) do
    case query(response) |> pages |> single_page do
      # もともとIntegerでparseされている
      %{"pageid" => pageid} -> pageid
      _ -> nil
    end
  end

  def revision_id(response) do
    case query(response) |> pages |> single_page |> revision do
      %{"revid" => revid, "sha1" => sha1} -> {revid, sha1}
      _ -> nil
    end
  end

  def parse_diff(response) do
    query(response) |> pages |> single_page |> revision |> diff
  end

  def url(response) do
    query(response) |> pages |> single_page |> fullurl
  end

  def parse_content(response) do
    query(response) |> pages |> single_page |> revision |> content
  end

  defp query(response) do
    response["query"]
  end

  defp pages(%{"pages" => pages}) do
    pages
  end

  defp single_page(pages) do
    page_num = hd(Map.keys(pages))

    case pages do
      %{^page_num => page} -> page
      _ -> nil
    end
  end

  defp categories(%{"categories" => categories}) do
    categories
  end

  defp revision(%{"revisions" => revisions}) do
    revisions |> hd
  end

  defp diff(%{"diff" => %{"*" => content, "from" => from, "to" => to}}) do
    case content |> String.length() do
      0 -> {:error, :no_content}
      _ -> {:ok, content, from, to}
    end
  end

  defp fullurl(%{"fullurl" => url}) do
    url
  end

  defp content(%{"*" => content}) do
    content
  end
end
