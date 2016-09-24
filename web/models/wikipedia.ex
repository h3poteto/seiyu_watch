defmodule SeiyuWatch.Wikipedia do
  use SeiyuWatch.Web, :model

  schema "wikipedias" do
    field :content, :string
    belongs_to :seiyu, SeiyuWatch.Seiyu

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :seiyu_id])
    |> assoc_constraint(:seiyu)
    |> validate_required([:content, :seiyu_id])
  end

  # table要素ではなく最初のp要素を取る
  def head(wikipedia) do
    wikipedia.content
    |> Floki.parse
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
