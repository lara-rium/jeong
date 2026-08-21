import Config

config :ueberauth, Ueberauth,
  providers: [
    google:
      {Ueberauth.Strategy.Google,
       [
         callback_url: "https://jeong.lara.lv/auth/google/callback",
         default_scope: "email profile"
       ]}
  ]

config :jeong, JeongWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"
config :swoosh, api_client: Swoosh.ApiClient.Req
config :swoosh, local: false
config :logger, level: :info
