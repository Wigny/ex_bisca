defmodule ExBisca.Play.Hand do
  alias ExBisca.Play.Deck.Card

  @type card :: Card.t()
  @type cards :: list(card)
  @type t :: %__MODULE__{cards: cards, score: non_neg_integer()}

  defstruct cards: [], score: 0

  @spec new(cards) :: t
  def new(cards \\ []), do: %__MODULE__{cards: cards}

  @spec deal(t, cards | card) :: t
  def deal(hand, cards) when is_list(cards) do
    %{hand | cards: Enum.concat(cards, hand.cards)}
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
