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
    items |> Enum.map(fn(i) ->
      i["link"]
    end)
  end
end
