defmodule ExBisca.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ExBiscaWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ExBisca.PubSub},
      # Start the Endpoint (http/https)
      ExBiscaWeb.Endpoint
      # Start a worker by calling: ExBisca.Worker.start_link(arg)
      # {ExBisca.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExBisca.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExBiscaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
