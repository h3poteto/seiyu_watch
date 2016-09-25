defmodule SeiyuWatch.ImageSearcher do

  alias SeiyuWatch.Repo
  alias SeiyuWatch.GoogleResponse

  def save_image(seiyu_id) do
    (SeiyuWatch.Seiyu
    |> Repo.get!(seiyu_id)
    ).name
    |> google_search_request
    |> GoogleResponse.get_response
    |> GoogleResponse.parse_images
  end

  def google_search_request(name) do
    "https://www.googleapis.com/customsearch/v1?key=#{google_api_key}&cx=#{google_custom_search_id}&searchType=image&q=#{URI.encode(name)}&num=10"
  end

  defp google_custom_search_id do
    System.get_env("GOOGLE_CUSTOM_SEARCH_ID")
  end

  defp google_api_key do
    System.get_env("GOOGLE_API_KEY")
  end
end
