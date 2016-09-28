# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :seiyu_watch,
  ecto_repos: [SeiyuWatch.Repo]

# Configures the endpoint
config :seiyu_watch, SeiyuWatch.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yH0lM398JsfQTovy2xvyxJaFF6N/ExnGDmv+GlmLw69pZVb87shhS67PP0eNbU9i",
  render_errors: [view: SeiyuWatch.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SeiyuWatch.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures quantum
config :quantum, cron: [
  # Every day
  "55 15 * * *": {SeiyuWatch.DiffParser, :parse_all_seiyus}
]

config :arc,
  bucket: System.get_env("S3_BUCKET"),
  asset_host: "https://s3-#{System.get_env("AWS_REGION")}.amazonaws.com/#{System.get_env("S3_BUCKET")}"

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  region: System.get_env("AWS_REGION"),
  s3: [
    scheme: "https://",
    host: "s3-#{System.get_env("AWS_REGION")}.amazonaws.com",
    region: System.get_env("AWS_REGION")
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
