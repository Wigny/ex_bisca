defmodule ExBisca.Play.Round do
  alias ExBisca.Play.Card
  alias ExBisca.Play.Player

  @type player_id :: Player.id()
  @type card :: Card.t()

  @type t :: %__MODULE__{
          stack: [{player_id, card}],
          current_player_id: player_id
        }

  fields = [:stack, :current_player_id]
  @enforce_keys fields
  defstruct fields

  @spec new(player_ids :: list(player_id)) :: t
  def new(player_ids) when length(player_ids) in [2, 4] do
    %__MODULE__{
      stack: Enum.map(player_ids, &{&1, nil}),
      current_player_id: List.first(player_ids)
    }
  end

  @spec restart(round :: t, next_player_id :: player_id) :: t
  def restart(round, next_player_id) do
    player_ids = Enum.map(round.stack, fn {player_id, _card} -> player_id end)
    next_player_index = Enum.find_index(player_ids, &(&1 == next_player_id))

    player_ids
    |> Enum.slide(next_player_index, 0)
    |> new()
  end

  @spec move(round :: t, player_id, card) :: t
  def move(round, player_id, card) do
    if player_id == round.current_player_id do
      stack = List.keystore(round.stack, player_id, 0, {player_id, card})

      next_player_id =
        Enum.find_value(stack, nil, fn {player_id, card} -> is_nil(card) && player_id end)

      %{round | stack: stack, current_player_id: next_player_id}
    else
      raise "it's not that player_id's turn to move"
    end
  end

  @spec winner_id(round :: t, trump :: card) :: player_id
  def winner_id(round, trump) do
    round.stack
    |> Enum.max_by(fn {_player_id, card} -> card end, &Card.captures?(&1, &2, trump))
    |> then(fn {player_id, _card} -> player_id end)
  end

  @spec score(round :: t) :: number
  def score(round) do
    Enum.sum_by(round.stack, fn {_player_id, card} -> card.score end)
  end

  @spec complete?(round :: t) :: boolean
  def complete?(round) do
    Enum.all?(round.stack, fn {_player_id, card} -> not is_nil(card) end)
  end
end
