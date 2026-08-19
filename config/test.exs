import Config

config :jeong, Jeong.Repo,
  username: "jeong",
  password: "",
  hostname: "localhost",
  database: "jeong_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :jeong, JeongWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "a+qJVjfOUxZNCLghKO9PRySL6ELsgJvpGllErrJDS5OuBBRwpnSlB15tLrnlwmFN",
  server: false

config :jeong, Jeong.Mailer, adapter: Swoosh.Adapters.Test
config :swoosh, :api_client, false
config :logger, level: :warning
config :phoenix, :plug_init_mode, :runtime
config :phoenix_live_view, enable_expensive_runtime_checks: true
config :phoenix, sort_verified_routes_query_params: true
