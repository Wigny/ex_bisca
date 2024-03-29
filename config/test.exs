import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ex_bisca, ExBiscaWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "QmBfYDVWKaE3XFUytDrgqrEAV1ycWDqp+mU/e4AFhzcojtksINK0jVuaVas1vrj7",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
