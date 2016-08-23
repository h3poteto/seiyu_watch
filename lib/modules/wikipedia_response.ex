defmodule SeiyuWatch.WikipediaResponse do

  def get_response(request) do
    url = request
    HTTPoison.start
    result = HTTPoison.get! url
    case result do
      %{status_code: 200, body: body} -> Poison.decode!(body)
      %{status_code: _code} -> nil
    end
  end

  def parse_categories(response) do
    query(response) |> pages |> single_page |> categories
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

  def find_seiyu_category(categories) do
    Enum.any?(categories, fn
      %{"ns" => _num, "title" => category} -> category == "Category:日本の女性声優"
    end
    ) || Enum.any?(categories, fn
      %{"ns" => _num, "title" => category} -> category == "Category:日本の男性声優"
    end
    )
  end

  def is_wikitext(response) do
    query(response) |> pages |> single_page |> head_revision |> wikitext |> String.length > 0
  end

  defp head_revision(%{"pageid" => _pageid, "ns" => _ns, "title" => _title, "revisions" => revisions}) do
    hd(revisions)
  end

  def wikitext(revision) do
    case revision do
      %{"contentmodel" => "wikitext"} -> revision["parsetree"]
      _ -> nil
    end
  end
end
