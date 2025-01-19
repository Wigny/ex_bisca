defmodule ExBisca.Play.Round do
  alias ExBisca.Play.Player
  alias ExBisca.Play.Card

  @type player_id :: Player.id()
  @type card :: Card.t()

  @type t :: %__MODULE__{
          stack: %{player_id => card},
          player_ids: list(player_id),
          current_player_id: player_id
        }

  @enforce_keys [:stack, :player_ids, :current_player_id]
  defstruct [:stack, :player_ids, :current_player_id]

  @spec new(player_ids :: list(player_id)) :: t
  def new(player_ids) when length(player_ids) in [2, 4] do
    %__MODULE__{
      stack: Map.from_keys(player_ids, nil),
      player_ids: player_ids,
      current_player_id: List.first(player_ids)
    }
  end

  @spec restart(round :: t, next_player_id :: player_id) :: t
  def restart(round, next_player_id) do
    current_player_index = player_index(round, next_player_id)
    player_ids = Enum.slide(round.player_ids, current_player_index, 0)
    new(player_ids)
  end

  @spec move(round :: t, player_id, card) :: t
  def move(round, player_id, card) do
    if player_id == round.current_player_id do
      stack = Map.update!(round.stack, player_id, fn nil -> card end)
      next_player_id = next_player_id(round)

      %{round | stack: stack, current_player_id: next_player_id}
    else
      raise "it's not that player_id's turn to move"
    end
  end

  @spec winner_id(round :: t, trump :: card) :: player_id
  def winner_id(round, trump) do
    cards = Map.values(round.stack)
    max_card = Enum.max(cards, &Card.captures?(&1, &2, trump))
    {winner_id, ^max_card} = Enum.find(round.stack, &match?({_player_id, ^max_card}, &1))

    winner_id
  end

  defp next_player_id(round) do
    current_player_index = player_index(round, round.current_player_id)

    Enum.at(round.player_ids, current_player_index + 1)
  end

  @spec score(round :: t) :: number
  def score(round) do
    cards = Map.values(round.stack)

    Enum.sum_by(cards, & &1.score)
  end

  @spec complete?(round :: t) :: boolean
  def complete?(round) do
    cards = Map.values(round.stack)

    not Enum.any?(cards, &is_nil/1)
  end

  defp player_index(round, player_id) do
    Enum.find_index(round.player_ids, &(&1 == player_id))
  end
end
