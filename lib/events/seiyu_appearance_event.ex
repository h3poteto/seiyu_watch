# Eventsは基本的にTaskを使うこと
# 将来的にはEventsだけTaskから切り離し，オリジナルのプロセスを作る可能性がある
defmodule SeiyuWatch.SeiyuAppearanceEvent do

  def after_update_appearance(update) do
    case update do
      {:ok, appearance} ->
        Task.start_link(fn -> SeiyuWatch.Seiyu.update_appearance(appearance.seiyu_id) end)
      _ -> update
    end
  end
end
