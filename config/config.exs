import Config

config :ex_bisca, ExBiscaWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: ExBiscaWeb.ErrorHTML],
    layout: false
  ],
  pubsub_server: ExBisca.PubSub,
  live_view: [signing_salt: "lyqGhp7a"]

config :bun,
  version: "1.1.45",
  ex_bisca: [
    args: ~w(
      build js/app.js
        --outdir=../priv/static/assets
        --external /fonts/*
        --external /images/*
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :tailwind,
  version: "4.0.0",
  ex_bisca: [
    args: ~w(
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, JSON

import_config "#{config_env()}.exs"
