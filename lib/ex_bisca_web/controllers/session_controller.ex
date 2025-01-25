defmodule ExBiscaWeb.SessionController do
  use ExBiscaWeb, :controller

  plug :redirect_if_logged

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"user" => %{"name" => username}}) do
    # TODO: verify unique username

    conn
    |> put_session(:username, username)
    |> redirect(to: ~p"/")
  end

  defp redirect_if_logged(conn, _opts) do
    if get_session(conn, :username) do
      conn
      |> redirect(to: ~p"/")
      |> halt()
    else
      conn
    end
  end
end
