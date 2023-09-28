defmodule ExBiscaWeb.RoomChannel do
  use LiveState.Channel, web_module: ExBiscaWeb

  @impl true
  def init(_channel, _payload, _socket), do: {:ok, %{foo: "bar"}}

  def handle_event("add_todo", todo, %{todos: todos}) do
    {:noreply, %{todos: [todo | todos]}}
  end
end
