import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :seiyu_watch, SeiyuWatchWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :seiyu_watch, SeiyuWatch.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_USER") || "postgres",
  password: System.get_env("DB_PASSWORD") || "",
  database: "seiyu_watch_test",
  hostname: System.get_env("DB_HOST") || "localhost",
  show_sensitive_data_on_connection_error: true,
  pool: Ecto.Adapters.SQL.Sandbox
