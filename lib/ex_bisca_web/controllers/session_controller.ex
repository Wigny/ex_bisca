defmodule ExBiscaWeb.SessionController do
  use ExBiscaWeb, :controller

  alias ExBisca.Play.Player

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"player" => player}) do
    player = Player.new(player["name"])

    conn
    |> put_session(:current_user, player)
    |> redirect(to: "/")
  end

  def delete(conn, _params) do
    conn
    |> clear_session()
    |> redirect(to: "/")
  end
end
