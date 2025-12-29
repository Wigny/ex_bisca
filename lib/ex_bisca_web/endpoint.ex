defmodule ExBiscaWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :ex_bisca

  @session_options [
    store: :cookie,
    key: "_ex_bisca_key",
    signing_salt: "9z1aQ4Qo",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]],
    longpoll: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :ex_bisca,
    gzip: not code_reloading?,
    only: ExBiscaWeb.static_paths(),
    raise_on_missing_only: code_reloading?

  if Code.ensure_loaded?(Tidewave) do
    plug Tidewave
  end

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug ExBiscaWeb.Router
end
