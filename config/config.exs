# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

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

# Configures quantum
config :seiyu_watch, SeiyuWatch.Scheduler,
  jobs: [
    # Every day
    {"12 16 * * *", {SeiyuWatch.DiffParser, :parse_all_seiyus, []}},
    {"29 16 * * *", {SeiyuWatch.ImageSearcher, :update_seiyu_images, []}}
  ]

config :arc,
  storage: Arc.Storage.S3,
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
import_config "#{Mix.env()}.exs"
