# Eventsは基本的にTaskを使うこと
# 将来的にはEventsだけTaskから切り離し，オリジナルのプロセスを作る可能性がある
defmodule SeiyuWatch.SeiyuDiffEvent do

  def after_update_diff(update) do
    case update do
      {:ok, diff} ->
        Task.start_link(fn -> SeiyuWatch.Seiyu.update_diff_timestamp(diff.seiyu_id) end)
      _ -> update
    end
  end
end
