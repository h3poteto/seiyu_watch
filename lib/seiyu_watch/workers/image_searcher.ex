defmodule SeiyuWatch.Workers.ImageSearcher do
  use Oban.Worker, queue: :default, max_attempts: 3
  alias SeiyuWatch.Repo
  alias SeiyuWatch.GoogleResponse
  require IEx
  @file_dir "/tmp"

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"seiyu_id" => seiyu_id}}) do
    save_image(seiyu_id)

    :ok
  end

  def save_image(seiyu_id) do
    seiyu =
      SeiyuWatch.Seiyu
      |> Repo.get!(seiyu_id)

    image =
      seiyu.name
      |> google_search_request
      |> GoogleResponse.get_response()
      |> GoogleResponse.parse_images()
      |> Enum.at(0)
      |> SeiyuWatch.Workers.ImageSearcher.download()

    case image do
      {:ok, file_name} -> SeiyuWatch.Workers.ImageSearcher.upload(file_name, seiyu)
      _ -> :error
    end
  end

  # ダウンロードでつかえそうなもの
  # http://qiita.com/mathhun/items/e78d779d2dca046a9dd8
  # http://stackoverflow.com/questions/30267943/elixir-download-a-file-image-from-a-url

  # 画像
  # https://40.media.tumblr.com/dcfce2754e8c4d8917373f0a1e905686/tumblr_npjs1wR1UQ1ux6tqqo1_1280.jpg
  def download(url) do
    result = HTTPoison.get!(url, [], follow_redirect: true)

    case result do
      %{status_code: 200, headers: headers, body: body} ->
        SeiyuWatch.Workers.ImageSearcher.save(url, headers, body)

      %{status_code: _code} ->
        {:error, nil}
    end
  end

  def save(url, headers, body) do
    name = Crypto.md5(url)

    file_name =
      case headers
           |> Enum.filter(fn h -> h |> elem(0) == "Content-Type" end)
           |> Enum.at(0)
           |> elem(1) do
        "image/jpeg" ->
          "#{name}.jpg"

        "image/gif" ->
          "#{name}.gif"

        "image/png" ->
          "#{name}.png"

        _ ->
          case SeiyuWatch.Workers.ImageSearcher.extension(url) do
            {:ok, ext} -> "#{name}.#{ext}"
          end
      end

    file_path = "#{@file_dir}/#{file_name}"

    case File.write!(file_path, body) do
      :ok -> {:ok, file_name}
      error -> {error, nil}
    end
  end

  def extension(url) do
    case Regex.named_captures(~r/\.(?<ext>...)$/, url) do
      %{"ext" => ext} -> {:ok, ext}
      _ -> {:error, nil}
    end
  end

  # http://smashingboxes.com/blog/image-upload-in-phoenix
  def upload(file, seiyu) do
    changeset =
      SeiyuWatch.Seiyu.changeset(seiyu, %{
        icon: %Plug.Upload{filename: file, path: "#{@file_dir}/#{file}"}
      })

    if changeset.valid? do
      Repo.update(changeset)
    else
      :error
    end
  end

  def google_search_request(name) do
    "https://www.googleapis.com/customsearch/v1?key=#{google_api_key()}&cx=#{google_custom_search_id()}&searchType=image&q=#{URI.encode(name)}&num=10"
  end

  defp google_custom_search_id do
    System.get_env("GOOGLE_CUSTOM_SEARCH_ID")
  end

  defp google_api_key do
    System.get_env("GOOGLE_API_KEY")
  end
end

defmodule SeiyuWatch.GoogleResponse do
  def get_response(request) do
    url = request
    result = HTTPoison.get!(url)

    case result do
      %{status_code: 200, body: body} -> Poison.decode!(body)
      %{status_code: _code} -> nil
    end
  end

  def parse_images(response) do
    response |> items |> images
  end

  defp items(%{"items" => items}) do
    items
  end

  defp images(items) do
    items
    |> Enum.map(fn i ->
      i["link"]
    end)
  end
end
