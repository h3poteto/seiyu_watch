# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

config :seiyu_watch, Oban,
  engine: Oban.Engines.Basic,
  notifier: Oban.Notifiers.Postgres,
  queues: [default: 10],
  repo: SeiyuWatch.Repo

# General application configuration
config :seiyu_watch,
  ecto_repos: [SeiyuWatch.Repo]

config :phoenix, :json_library, Jason

# Configures the endpoint
config :seiyu_watch, SeiyuWatchWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yH0lM398JsfQTovy2xvyxJaFF6N/ExnGDmv+GlmLw69pZVb87shhS67PP0eNbU9i",
  render_errors: [view: SeiyuWatchWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: SeiyuWatch.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures oban
config :seiyu_watch, Oban,
  plugins: [
    {Oban.Plugins.Cron,
     crontab: [
       {"12 16 * * *", SeiyuWatch.Workers.ParseSeiyus, args: %{}, queue: :default},
       {"29 16 * * *", SeiyuWatch.Workers.FillAllImages, args: %{}, queue: :default}
     ]}
  ]

config :waffle,
  storage: Waffle.Storage.S3,
  virtual_host: true,
  bucket: {:system, "AWS_S3_BUCKET"}

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  region: "ap-northeast-1"

config :scrivener_html,
  routes_helper: SeiyuWatch.Router.Helpers,
  view_style: :bootstrap_v4

config :seiyu_watch, :subscriber_delay, update_diff: 300_000

config :rollbax, enabled: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
