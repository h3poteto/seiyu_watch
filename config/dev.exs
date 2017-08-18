use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :seiyu_watch, SeiyuWatchWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/webpack/bin/webpack.js", "--watch-stdin", "--progress", "--colors",
                    cd: Path.expand("../assets", __DIR__)]]


# Watch static and templates for browser reloading.
config :seiyu_watch, SeiyuWatchWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/seiyu_watch_web/views/.*(ex)$},
      ~r{lib/seiyu_watch_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, backends: [:console, SlackLogger]
config :logger, SlackLogger,
  level: :error,
  hook_url: {:system, "SLACK_WEBHOOK_URL"},
  channel: "#playground",
  username: "seiyu_watch-develop"


# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :seiyu_watch, SeiyuWatch.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: System.get_env("DB_USER") || "root",
  password: System.get_env("DB_PASSWORD") || "",
  database: "seiyu_watch_dev",
  hostname: System.get_env("DB_HOST") || "localhost",
  charset: "utf8mb4",
  pool_size: 10


config :seiyu_watch, :subscriber_delay,
  update_diff: 1
