use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :seiyu_watch, SeiyuWatch.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :seiyu_watch, SeiyuWatch.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: System.get_env("DB_USER") || "root",
  password: System.get_env("DB_PASSWORD") || "",
  database: "seiyu_watch_test",
  hostname: System.get_env("DB_HOST") || "localhost",
  charset: "utf8mb4",
  pool: Ecto.Adapters.SQL.Sandbox
