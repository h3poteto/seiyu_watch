defmodule SeiyuWatch.Workers.FillAllImages do
  use Oban.Worker, queue: :default, max_attempts: 3
  alias SeiyuWatch.Repo

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    SeiyuWatch.Seiyu
    |> Repo.all()
    |> Enum.filter(fn s -> s.icon == nil end)
    |> Enum.each(fn s ->
      %{"seiyu_id" => s.id}
      |> SeiyuWatch.Workers.ImageSearcher.new()
      |> Oban.insert()
    end)

    :ok
  end
end
