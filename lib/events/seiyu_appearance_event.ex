# Eventsは基本的にTaskを使うこと
# 将来的にはEventsだけTaskから切り離し，オリジナルのプロセスを作る可能性がある
defmodule SeiyuWatch.SeiyuAppearanceEvent do

  import Ecto.Query, only: [from: 2]
  alias SeiyuWatch.Repo

  def after_update_appearance(update) do
    case update do
      {:ok, appearance} ->
        Task.start_link(fn -> SeiyuWatch.Seiyu.update_appearance(appearance.seiyu_id) end)
        Task.start_link(fn -> create_diff(appearance) end)
      _ -> update
    end
  end

  def create_diff(appearance) do
    current_appearance = appearance
    seiyu = (appearance
      |> Repo.preload(:seiyu)
    ).seiyu
    |> Repo.preload(seiyu_appearances: (from a in SeiyuWatch.SeiyuAppearance, order_by: [desc: a.inserted_at]))
    case seiyu.seiyu_appearances |> Enum.at(1) do
      nil -> {:ok, :no_content}
      value -> SeiyuWatch.AppearancesDiff.create(value, current_appearance)
    end
  end
end
