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

  @spec start(list(player_id), player_id) :: t
  def start(players, current_player) do
    round = %__MODULE__{stack: Enum.map(players, &{&1, nil}), current_player: current_player}

    current_player_index = current_player_index(round)
    players_length = round |> players() |> length()

    %__MODULE__{round | stack: Enum.slide(round.stack, current_player_index..players_length, 0)}
  end

  @spec restart(t, player_id) :: t
  def restart(round, current_player) do
    players = players(round)

    start(players, current_player)
  end

  @spec move(t, player_id, card) :: t
  def move(round, player_id, card) do
    if player_id == round.current_player do
      stack = Keyword.update!(round.stack, player_id, fn nil -> card end)
      %{round | stack: stack}
    else
      throw("it's not that player's turn to move")
    end
  end

  @spec winner(t, card) :: player_id
  def winner(round, trump) do
    cards = cards(round)
    max_card = Enum.max(cards, &Card.captures?(&1, &2, trump))
    {winner, _max_card} = Enum.find(round.stack, &match?({_player_id, ^max_card}, &1))

    winner
  end

  @spec next_player(t) :: player_id
  def next_player(round) do
    players = players(round)
    index = current_player_index(round)

    Enum.at(players, index + 1) || List.first(players)
  end

  @spec score(t) :: number
  def score(round) do
    cards = cards(round)
    scores = Enum.map(cards, &Card.score/1)

    Enum.sum(scores)
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
