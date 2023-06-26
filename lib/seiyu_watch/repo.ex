defmodule SeiyuWatch.Repo do
  use Ecto.Repo,
    otp_app: :seiyu_watch,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 12
end
