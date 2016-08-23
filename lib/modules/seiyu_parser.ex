defmodule SeiyuWatch.SeiyuParser do

  defmacro __using__(_opts) do
    quote do
      require SeiyuWatch.Seiyu
    end
  end

  alias SeiyuWatch.Repo

  def save(name) do
    # 声優であることの確認をする
    if wikipedia_category_request(name)
    |> get_response
    |> parse_categories
    |> find_seiyu_category do
      # wikitextであることの確認をする
      if wikipedia_page_request(name)
      |> get_response
      |> query
      |> pages
      |> single_page
      |> head_revision
      |> wikitext
      |> String.length > 0 do
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

  defp get_response(request) do
    url = request
    HTTPoison.start
    result = HTTPoison.get! url
    case result do
      %{status_code: 200, body: body} -> Poison.decode!(body)
      %{status_code: _code} -> nil
    end
  end

  defp parse_categories(response) do
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

  # TODO 男性声優も対応してあげようぜ
  defp find_seiyu_category(categories) do
    Enum.any?(categories, fn
      %{"ns" => _num, "title" => category} -> category == "Category:日本の女性声優"
    end
    ) || Enum.any?(categories, fn
      %{"ns" => _num, "title" => category} -> category == "Category:日本の男性声優"
    end
    )
  end

  defp wikipedia_page_request(name) do
    # contetnmodel == wikitextのもであればparsetree指定でxml parseされたものが帰る
    "https://ja.wikipedia.org/w/api.php?format=json&action=query&prop=revisions&titles=#{URI.encode(name)}&rvprop=parsetree|contentmodel"
  end

  defp head_revision(%{"pageid" => _pageid, "ns" => _ns, "title" => _title, "revisions" => revisions}) do
    hd(revisions)
  end

  defp wikitext(revision) do
    case revision do
      %{"contentmodel" => "wikitext"} -> revision["parsetree"]
      _ -> nil
    end
  end
end
