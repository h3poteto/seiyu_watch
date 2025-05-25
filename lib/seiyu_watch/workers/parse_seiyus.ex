defmodule SeiyuWatch.Workers.ParseSeiyus do
  use Oban.Worker, queue: :default, max_attempts: 3
  alias SeiyuWatch.Repo

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    SeiyuWatch.Seiyu
    |> Repo.all()
    |> Enum.each(fn s ->
      delay =
        (:rand.uniform() * Application.get_env(:seiyu_watch, :subscriber_delay)[:update_diff])
        |> round()

      %{"seiyu_id" => s.id}
      |> SeiyuWatch.Workers.DiffParser.new(
        scheduled_at: DateTime.utc_now() |> DateTime.add(delay, :millisecond)
      )
      |> Oban.insert()
    end)

    :ok
  end
end
