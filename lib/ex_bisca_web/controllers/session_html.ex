defmodule ExBiscaWeb.SessionHTML do
  use ExBiscaWeb, :html

  def new(assigns) do
    ~H"""
    <.form :let={f} for={@form} as={:user} action={~p"/session"}>
      <input
        id={f[:name].id}
        name={f[:name].name}
        type="text"
        autocomplete="name"
        required
        placeholder="Nickname"
      />
      <button type="submit">
        Join
      </button>
    </.form>
    """
  end
end
