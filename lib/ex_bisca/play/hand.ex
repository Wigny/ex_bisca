defmodule ExBisca.Play.Hand do
  alias ExBisca.Play.Card

  @type card :: Card.t()
  @type cards :: list(card)
  @type t :: %__MODULE__{cards: cards, score: non_neg_integer()}

  defstruct cards: [], score: 0

  @spec new() :: t
  def new, do: %__MODULE__{}

  @spec new(cards) :: t
  def new(cards) when length(cards) == 3, do: %__MODULE__{cards: cards}

  @spec deal(t, cards) :: t
  def deal(hand, cards) when is_list(cards) do
    cards = Enum.concat(hand.cards, cards)

    if length(cards) <= 3 do
      %{hand | cards: cards}
    else
      raise "invalid number of cards in a hand"
    end
  end

  @spec drop(t, card) :: t
  def drop(hand, card) do
    if card in hand.cards do
      %{hand | cards: List.delete(hand.cards, card)}
    else
      raise "card not found in the hand"
    end
  end

  @spec increase_score(t, non_neg_integer) :: t
  def increase_score(hand, score) do
    %{hand | score: hand.score + score}
  end
end
