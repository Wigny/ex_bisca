defmodule ExBisca.Play.Round do
  use TypedStruct

  alias ExBisca.Play
  alias ExBisca.Play.Deck.Card

  @typep player_id :: Play.player_id()
  @typep card :: Card.t()

  typedstruct enforce: true do
    field :stack, list({player_id, card})
    field :current_player, player_id
  end

  def new(stack, current_player) do
    struct!(__MODULE__, stack: stack, current_player: current_player)
  end

  @spec start(players :: list(player_id), current_player :: player_id) :: t
  def start(players, current_player) do
    round = %__MODULE__{stack: Enum.map(players, &{&1, nil}), current_player: current_player}

    current_player_index = current_player_index(round)
    players_length = round |> players() |> length()

    %__MODULE__{round | stack: Enum.slide(round.stack, current_player_index..players_length, 0)}
  end

  @spec restart(round, current_player :: player_id) :: round when round: t
  def restart(round, current_player) do
    players = players(round)

    start(players, current_player)
  end

  # todo: refactor to change the current_player of the round
  @spec move(round, player_id, card) :: round when round: t
  def move(round, player_id, card) do
    if player_id == round.current_player do
      stack =
        Enum.map(round.stack, fn
          {^player_id, nil} -> {player_id, card}
          move -> move
        end)

      %__MODULE__{round | stack: stack}
    else
      raise "It's not that player's turn to move."
    end
  end

  @spec winner(round :: t, trump :: card) :: player_id
  def winner(round, trump) do
    cards = cards(round)
    max_card = Enum.max(cards, &Card.captures?(&1, &2, trump))
    {winner, _max_card} = Enum.find(round.stack, &match?({_player_id, ^max_card}, &1))

    winner
  end

  # todo: refactor to get the first nil of the stack
  # todo: refactor to remove the next_player function
  @spec next_player(round :: t) :: player_id
  def next_player(round) do
    players = players(round)
    index = current_player_index(round)

    Enum.at(players, index + 1, List.first(players))
  end

  @spec score(round :: t) :: number
  def score(round) do
    cards = cards(round)
    scores = Enum.map(cards, &Card.score/1)

    Enum.sum(scores)
  end

  @spec complete?(round :: t) :: boolean
  def complete?(round) do
    cards = cards(round)
    not Enum.any?(cards, &is_nil/1)
  end

  defp current_player_index(round) do
    players = players(round)

    Enum.find_index(players, &(&1 == round.current_player))
  end

  defp players(round), do: Enum.map(round.stack, fn {key, _value} -> key end)
  defp cards(round), do: Enum.map(round.stack, fn {_key, value} -> value end)
end
