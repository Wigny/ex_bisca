defmodule ExBiscaWeb.Router do
  use ExBiscaWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ExBiscaWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # scope "/", ExBiscaWeb do
  # end

  scope "/", ExBiscaWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/session", SessionController, only: [:new, :create, :delete], singleton: true
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExBiscaWeb do
  #   pipe_through :api
  # end

  defp fetch_current_user(conn, _) do
    current_user = get_session(conn, :current_user)
    assign(conn, :current_user, current_user)
  end
end
