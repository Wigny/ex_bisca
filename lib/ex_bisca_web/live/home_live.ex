defmodule ExBiscaWeb.HomeLive do
  use ExBiscaWeb, :live_view

  on_mount {ExBiscaWeb.UserLiveAuth, :ensure_authenticated}

  @impl true
  def render(assigns) do
    ~H"""
    <p>Hello, {@player.name}</p>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
