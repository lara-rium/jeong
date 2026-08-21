import Config

config :jeong, Jeong.Repo,
  username: "jeong",
  password: "",
  hostname: "localhost",
  database: "jeong_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :jeong, JeongWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "3WrShwSeeCzkTI2scP/hfDo4xTbBhJGq9boZQKoz4ESzRph0xnEgm/lbUwJ+a4Rh",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:jeong, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:jeong, ~w(--watch)]}
  ]

config :phoenix_live_view,
  debug_heex_annotations: true,
  debug_attributes: true,
  enable_expensive_runtime_checks: true

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile"]}
  ]

config :jeong, dev_routes: true
config :logger, :default_formatter, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
config :swoosh, :api_client, false
