defmodule SeiyuWatch.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    :opentelemetry_cowboy.setup()
    OpentelemetryPhoenix.setup(adapter: :cowboy2)
    OpentelemetryEcto.setup([:seiyu_watch, :repo], [{:db_statement, :enabled}])

    # Define workers and child supervisors to be supervised
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: SeiyuWatch.PubSub},
      # Start the Ecto repository
      SeiyuWatch.Repo,
      # Start the endpoint when the application starts
      SeiyuWatchWeb.Endpoint,
      {Oban, Application.fetch_env!(:seiyu_watch, Oban)},
      # Start your own worker by calling: SeiyuWatch.Worker.start_link(arg1, arg2, arg3)
      # worker(SeiyuWatch.Worker, [arg1, arg2, arg3]),
      SeiyuWatchWeb.Telemetry
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SeiyuWatch.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SeiyuWatchWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
