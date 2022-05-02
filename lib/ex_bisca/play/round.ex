defmodule ExBisca.Play.Round do
  use TypedStruct

  alias ExBisca.Play
  alias ExBisca.Play.Deck.Card

  @type player_id :: Play.player_id()
  @type card :: Card.t()

  typedstruct enforce: true do
    field :stack, list({player_id, card})
    field :current_player, player_id
  end

  def start(players, current_player) do
    current_player_index = Enum.find_index(players, &(&1 == current_player))
    players_length = length(players)

    ordered_players = Enum.slide(players, current_player_index..players_length, 0)
    stack = Enum.map(ordered_players, &{&1, nil})

    %__MODULE__{stack: stack, current_player: current_player}
  end

  def restart(round, current_player) do
    players = stack_players(round)

    start(players, current_player)
  end

  def move(round, player_id, card) do
    if player_id == round.current_player do
      stack = Keyword.update!(round.stack, player_id, fn _card -> card end)
      %{round | stack: stack}
    else
      throw("it's not that player's turn to move")
    end
  end

  def winner(round, trump) do
    cards = stack_cards(round)
    max_card = Enum.max(cards, &Card.captures?(&1, &2, trump))
    {winner, ^max_card} = Enum.find(round.stack, &match?({_, ^max_card}, &1))

    winner
  end

  def next_player(round) do
    players = stack_players(round)
    index = Enum.find_index(players, &(&1 == round.current_player))

    Enum.at(players, index + 1) || List.first(players)
  end

  def score(round) do
    cards = stack_cards(round)
    scores = Enum.map(cards, &Card.score/1)

    Enum.sum(scores)
  end

  def complete?(round) do
    cards = stack_cards(round)
    not Enum.any?(cards, &is_nil/1)
  end

  defp stack_players(round), do: Keyword.keys(round.stack)
  defp stack_cards(round), do: Keyword.values(round.stack)
end
