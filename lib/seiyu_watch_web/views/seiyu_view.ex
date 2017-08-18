defmodule SeiyuWatchWeb.SeiyuView do
  use SeiyuWatchWeb, :view
  use Scrivener.HTML

  def recently_updated?(seiyu) do
    seiyu.diffs_updated_at != nil && seiyu.diffs_updated_at |> Timex.after?(Timex.shift(Timex.now, days: -7))
  end
end
