defmodule ExBiscaWeb.Router do
  use ExBiscaWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ExBiscaWeb do
    pipe_through :api
  end
end
