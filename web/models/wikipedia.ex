defmodule SeiyuWatch.Wikipedia do
  use SeiyuWatch.Web, :model

  require IEx

  schema "wikipedias" do
    field :content, :string
    belongs_to :seiyu, SeiyuWatch.Seiyu

    timestamps()
  end

  @required_fields ~w(content)
  @optional_fields ~w()

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> assoc_constraint(:seiyu)
  end

  # table要素ではなく最初のp要素を取る
  def head(wikipedia) do
    case wikipedia do
      nil -> "No description"
      _ ->
        parse = wikipedia.content
        |> Floki.parse

        case parse |> is_list do
          false -> wrap_parser(parse)
          true -> list_parser(parse)
        end
    end
  end

  # wikipediaのhtml構造として，ラッパーとなるdivが存在するケース
  # divの中に<p>...</p>や<table>が眠っている
  def wrap_parser({"div", _class, list}) do
    list
    |> list_parser()
  end

  # wrapされているが，想定されていないhtml構造の場合のハンドリング
  def wrap_parser(_) do
    "No description"
  end

  def list_parser([{"div", class, list}|tail]) do
    if list
    |> Enum.any?(
    fn(l) ->
      case l do
        {"p", _, _} -> true
        _ -> false
      end
    end) do
      {"div", class, list}
      |> wrap_parser()
    else
      tail
      |> list_parser()
    end
  end

  # wikipediaのhtml構造として，ラッパーとなるdivが存在しない場合のパース
  # <p>...</p><p>...</p>の羅列で構成されている場合が多いので
  # その先頭のp要素をいくつか取得する
  def list_parser(parse) do
    parse
    |> Enum.map(fn(c) ->
      case c do
        {"p", _, _} -> c
        _ -> nil
      end
    end)
    |> Enum.reject(fn(x) ->
      x == nil
    end)
    |> Enum.slice(0, 2)
    |> Floki.raw_html
  end
end
