defmodule SeiyuWatch.ImageSearcher do

  alias SeiyuWatch.Repo
  alias SeiyuWatch.GoogleResponse

  require IEx
  def save_image(seiyu_id) do
    (SeiyuWatch.Seiyu
    |> Repo.get!(seiyu_id)
    ).name
    |> google_search_request
    |> GoogleResponse.get_response
    |> GoogleResponse.parse_images
    |> Enum.at(0)
    |> download
  end

  # ダウンロードでつかえそうなもの
  # http://qiita.com/mathhun/items/e78d779d2dca046a9dd8
  # http://stackoverflow.com/questions/30267943/elixir-download-a-file-image-from-a-url

  # 画像
  # https://40.media.tumblr.com/dcfce2754e8c4d8917373f0a1e905686/tumblr_npjs1wR1UQ1ux6tqqo1_1280.jpg
  def download(url) do
    result = HTTPoison.get!(url)
    case result do
      %{status_code: 200, headers: headers, body: body} -> save(url, headers, body)
      %{status_code: _code} -> :error
    end
  end


  def save(url, headers, body) do
    name = Crypto.md5(url)
    file_name = case headers |> Enum.filter(fn(h) -> h |> elem(0) == "Content-Type" end) |> Enum.at(0) |> elem(1) do
      "image/jpeg" -> "#{name}.jpg"
      "image/gif" -> "#{name}.gif"
      "image/png" -> "#{name}.png"
    end
    File.write!("/tmp/#{file_name}", body)
  end

  # http://smashingboxes.com/blog/image-upload-in-phoenix
  def upload(file) do
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
