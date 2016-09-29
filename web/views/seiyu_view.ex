defmodule SeiyuWatch.SeiyuView do
  use SeiyuWatch.Web, :view

  def recently_updated?(seiyu) do
    seiyu.diffs_updated_at != nil && seiyu.diffs_updated_at |> Ecto.DateTime.to_erl |> Timex.to_datetime |> Timex.after?(Timex.shift(Timex.now, days: -7))
  end
end
