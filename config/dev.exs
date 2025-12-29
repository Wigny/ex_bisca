import Config

config :ex_bisca, ExBiscaWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "cAGoYADvdDAo4dulcXRls7/i07lwVAUtBc6pcXY7MpWVOMc4fundLb/93XOheRju",
  watchers: [
    bun_js: {Bun, :install_and_run, [:js, ~w(--sourcemap=inline --watch)]},
    bun_css: {Bun, :install_and_run, [:css, ~w(--watch)]}
  ]

config :ex_bisca, ExBiscaWeb.Endpoint,
  live_reload: [
    web_console_logger: true,
    patterns: [
      ~r"priv/static/(?!uploads/).*\.(js|css|png|jpeg|jpg|gif|svg)$"E,
      ~r"lib/ex_bisca_web/router\.ex$"E,
      ~r"lib/ex_bisca_web/(controllers|live|components)/.*\.(ex|heex)$"E
    ]
  ]

# Enable dev routes for dashboard and mailbox
config :ex_bisca, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :default_formatter, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Include debug annotations and locations in rendered markup.
  # Changing this configuration will require mix clean and a full recompile.
  debug_heex_annotations: true,
  debug_attributes: true,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true
