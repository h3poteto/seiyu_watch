defmodule SeiyuWatch.SeiyuEvent do
  def after_create(create) do
    case create do
      {:ok, seiyu} ->
        Task.start_link(fn -> SeiyuWatch.ImageSearcher.save_image(seiyu.id) end)
      _ -> create
    end
  end
end
