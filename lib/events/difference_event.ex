# Eventsは基本的にTaskを使うこと
# 将来的にはEventsだけTaskから切り離し，オリジナルのプロセスを作る可能性がある
defmodule SeiyuWatch.DifferenceEvent do

  def after_update_diff(update) do
    case update do
      {:ok, diff} ->
        Task.start(fn -> SeiyuWatch.Seiyu.update_diff_timestamp(diff.seiyu_id) end)
        Task.start(fn -> SeiyuWatch.WikiParser.update_wiki(diff.seiyu_id) end)
      _ -> update
    end
  end
end
