defmodule ExBisca.Game do
  use GenServer

  alias ExBisca.GameRegistry
  alias ExBisca.{Card, Player, Round}
  alias Phoenix.PubSub

  # Client

  def start_link(args) do
    game_id = Keyword.fetch!(args, :id)

    GenServer.start_link(
      __MODULE__,
      %{game_id: game_id, player_ids: Keyword.fetch!(args, :player_ids)},
      name: GameRegistry.via(game_id)
    )
  end

  def move(game_id, %Player{} = player, %Card{} = card) do
    GenServer.cast(GameRegistry.via(game_id), {:move, player, card})
  end

  # Server (callbacks)

  @impl true
  def init(%{game_id: game_id, player_ids: player_ids}) do
    round = Round.start(player_ids)

    {:ok, %{game_id: game_id, round: round}}
  end

  @impl true
  def handle_cast({:move, %Player{} = player, %Card{} = card}, state) do
    round = Round.move(state.round, player.id, card)

    {:noreply, %{state | round: round}}
  end

  defp broadcast(game_id, message) do
    PubSub.broadcast(ExBisca.PubSub, "game:#{game_id}", message)
  end

  defp broadcast(game_id, player_id, message) do
    PubSub.broadcast(ExBisca.PubSub, "game:#{game_id}:#{player_id}", message)
  end
end
