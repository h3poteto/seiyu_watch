import Config

# For production, we configure the host to read the PORT
# from the system environment. Therefore, you will need
# to set PORT=80 before running your server.
#
# You should also configure the url host to something
# meaningful, we use this information when generating URLs.
#
# Finally, we also include the path to a manifest
# containing the digested version of static files. This
# manifest is generated by the mix phoenix.digest task
# which you typically run after static files are built.
config :seiyu_watch, SeiyuWatchWeb.Endpoint,
  http: [port: 8080],
  url: [host: "seiyu.watch", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

# Do not print debug messages in production
config :logger, level: :info
config :logger, backends: [:console]

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :seiyu_watch, SeiyuWatch.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [port: 443,
#               keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#               certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables return an absolute path to
# the key and cert in disk or a relative path inside priv,
# for example "priv/ssl/server.key".
#
# We also recommend setting `force_ssl`, ensuring no data is
# ever sent via http, always redirecting to https:
#
#     config :seiyu_watch, SeiyuWatch.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :seiyu_watch, SeiyuWatch.Endpoint, server: true
#

config :waffle,
  bucket: "seiyu-watch",
  asset_host: "https://s3-ap-northeast-1.amazonaws.com/seiyu-watch"

config :ex_aws,
  # We have to set dummy profile to use web identity adapter.
  # So this profile does not exist and don't prepare it.
  secret_access_key: [{:awscli, "profile_name", 30}],
  access_key_id: [{:awscli, "profile_name", 30}],
  awscli_auth_adapter: ExAws.STS.AuthCache.AssumeRoleWebIdentityAdapter

config :ex_aws, :s3,
  scheme: "https://",
  host: "s3-ap-northeast-1.amazonaws.com",
  region: "ap-northeast-1"
