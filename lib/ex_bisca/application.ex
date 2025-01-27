defmodule ExBisca.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: ExBisca.PubSub},
      ExBiscaWeb.Endpoint,
      ExBisca.GameRegistry,
      ExBisca.GameSupervisor
    ]

    opts = [strategy: :one_for_one, name: ExBisca.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    ExBiscaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
