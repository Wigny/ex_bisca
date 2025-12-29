import Config

config :ex_bisca,
  generators: [timestamp_type: :utc_datetime]

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
  version: "1.3.5",
  js: [
    args: ~w(
      build js/app.js
        --outdir=../priv/static/assets/js
        --external /fonts/*
        --external /images/*
    ),
    cd: Path.expand("../assets", __DIR__)
  ],
  css: [
    args: ~w(
      run tailwindcss
        --input=css/app.css
        --output=../priv/static/assets/css/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :phoenix_live_view, :colocated_js,
  target_directory: Path.expand("../assets/node_modules/phoenix-colocated", __DIR__)

config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, JSON

import_config "#{config_env()}.exs"
