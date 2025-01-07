defmodule ExBisca.Play.Round do
  alias ExBisca.Play.Player
  alias ExBisca.Play.Deck.Card

  @type player :: Player.t()
  @type card :: Card.t()

  @type t :: %__MODULE__{stack: list({player, card}), current_player: player}

  @enforce_keys [:stack, :current_player]
  defstruct [:stack, :current_player]

  @spec start(list(player), player) :: t
  def start(players, current_player) do
    round = %__MODULE__{stack: Enum.map(players, &{&1, nil}), current_player: current_player}

    current_player_index = current_player_index(round)
    players_length = length(players(round))

    %__MODULE__{round | stack: Enum.slide(round.stack, current_player_index..players_length, 0)}
  end

  @spec restart(t, player) :: t
  def restart(round, current_player) do
    players = players(round)

    start(players, current_player)
  end

  @spec move(t, player, card) :: t
  def move(round, player, card) do
    if player == round.current_player do
      stack = put_in(round.stack, [player], card)
      %{round | stack: stack}
    else
      raise "it's not that player's turn to move"
    end
  end

  @spec winner(t, card) :: player
  def winner(round, trump) do
    cards = cards(round)
    max_card = Enum.max(cards, &Card.captures?(&1, &2, trump))
    {winner, _max_card} = Enum.find(round.stack, &match?({_player, ^max_card}, &1))

    winner
  end

  @spec next_player(t) :: player
  def next_player(round) do
    players = players(round)
    index = current_player_index(round)

    Enum.at(players, index + 1, List.first(players))
  end

  @spec score(t) :: number
  def score(round) do
    cards = cards(round)

    Enum.sum_by(cards, & &1.score)
  end

  @spec complete?(t) :: boolean
  def complete?(round) do
    cards = cards(round)

    not Enum.any?(cards, &is_nil/1)
  end

  defp current_player_index(round) do
    players = players(round)

    Enum.find_index(players, &(&1 == round.current_player))
  end

  defp players(round), do: Keyword.keys(round.stack)
  defp cards(round), do: Keyword.values(round.stack)
end
