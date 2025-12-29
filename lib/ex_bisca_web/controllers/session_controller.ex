defmodule ExBiscaWeb.SessionController do
  use ExBiscaWeb, :controller

  plug :redirect_if_logged

  def new(conn, _params) do
    form = Phoenix.Component.to_form(%{"name" => nil}, as: "user")
    render(conn, :new, form: form)
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
