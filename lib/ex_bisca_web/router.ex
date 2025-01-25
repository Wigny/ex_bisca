defmodule ExBiscaWeb.Router do
  use ExBiscaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ExBiscaWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", ExBiscaWeb do
    pipe_through :browser

    resources "/session", SessionController, only: [:new, :create], singleton: true
    live "/", HomeLive
  end
end
