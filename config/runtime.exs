import Config

if config_env() == :prod do
  config :seiyu_watch, SeiyuWatchWeb.Endpoint,
    http: [port: String.to_integer(System.get_env("PORT") || "8080")],
    secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

  config :rollbax,
    access_token: System.fetch_env!("ROLLBAR_ACCESS_TOKEN"),
    environment: "production",
    enable_crash_reports: true,
    enabled: true

  # Configure your database
  config :seiyu_watch, SeiyuWatch.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: System.fetch_env!("DB_USER"),
    password: System.fetch_env!("DB_PASSWORD"),
    database: "seiyu_watch",
    hostname: System.fetch_env!("DB_HOST"),
    show_sensitive_data_on_connection_error: true,
    port: 5432,
    pool_size: 3
end
