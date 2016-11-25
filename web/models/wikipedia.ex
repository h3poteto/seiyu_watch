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
          false -> "No description"
          true ->
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
  end
end
