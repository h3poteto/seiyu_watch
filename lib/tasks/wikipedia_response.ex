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

  def find_seiyu_category(categories) do
    Enum.any?(categories, fn
      %{"ns" => _num, "title" => category} -> category == "Category:日本の女性声優"
    end
    ) || Enum.any?(categories, fn
      %{"ns" => _num, "title" => category} -> category == "Category:日本の男性声優"
    end
    )
  end

  def page_id(response) do
    case query(response) |> pages |> single_page do
      %{"pageid" => pageid} -> pageid # もともとIntegerでparseされている
      _ -> nil
    end
  end

  def revision_id(response) do
    case query(response) |> pages |> single_page |> revision do
      %{"revid" => revid, "sha1" => sha1} -> {revid, sha1}
      _ -> nil
    end
  end

  def appearances(response) do
    query(response) |> pages |> single_page |> revision |> parse_content
  end

  def to_html(appearances) do
    appearances |> Floki.raw_html
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

  defp parse_content(%{"*" => content}) do
    content |> Floki.parse |> html_parse
  end

  defp html_parse([x|tl]) do
    case x do
      {tag, _, [{_, _, ["出演作品"]}, _]} -> show_list(tl, tag)
      _ -> html_parse(tl)
    end
  end

  defp show_list([x|tl], tag) do
    case x do
      {^tag, _, _} -> []
      _ ->
        [x] ++ show_list(tl, tag)
    end
  end
end
