defmodule ExBisca.Play.Round do
  use TypedStruct

  alias ExBisca.Play
  alias ExBisca.Play.Deck.Card

  @type player_id :: Play.player_id()
  @type card :: Card.t()

  typedstruct opaque: true do
    field :stack, %{player_id => card | nil}
    field :current_player, player_id, enforce: true
  end

  def start(players, current_player) do
    %__MODULE__{
      stack: Map.new(players, &{&1, nil}),
      current_player: current_player
    }
  end

  def restart(round, current_player) do
    stack = Map.new(round.stack, fn {player, _card} -> {player, nil} end)

    %__MODULE__{stack: stack, current_player: current_player}
  end

  def move(round, player_id, card) when player_id == round.current_player do
    %{round | stack: %{round.stack | player_id => card}}
  end

  def winner(round, trump) do
    max_card = round.stack |> Map.values() |> Enum.max(&Card.captures?(&1, &2, trump))
    {winner, ^max_card} = Enum.find(round.stack, &match?({_, ^max_card}, &1))

    winner
  end

  def next_player(round) do
    players = Map.keys(round.stack)
    index = Enum.find_index(players, &(&1 == round.current_player))

    Enum.at(players, index + 1) || List.first(players)
  end

  def score(round) do
    cards = Map.values(round.stack)
    cards |> Enum.map(&Card.score/1) |> Enum.sum()
  end
end
