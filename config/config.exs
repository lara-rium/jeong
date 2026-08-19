import Config

config :jeong,
  ecto_repos: [Jeong.Repo],
  generators: [timestamp_type: :utc_datetime]

config :jeong, JeongWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: JeongWeb.ErrorHTML, json: JeongWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Jeong.PubSub,
  live_view: [signing_salt: "Z4ENlhAE"]

config :phoenix_live_view,
  root_tag_attribute: "phx-r"

config :esbuild,
  version: "0.25.4",
  jeong: [
    args:
      ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

config :tailwind,
  version: "4.3.0",
  jeong: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :jeong, Jeong.Mailer, adapter: Swoosh.Adapters.Local
config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
