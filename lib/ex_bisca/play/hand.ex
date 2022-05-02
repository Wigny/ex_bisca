defmodule ExBisca.Play.Hand do
  use TypedStruct

  alias ExBisca.Play.Deck.Card

  @type card :: Card.t()
  @type cards :: list(card)

  typedstruct do
    field :cards, cards, default: []
    field :score, integer, default: 0
  end

  @spec new(cards) :: t
  def new(cards \\ []), do: %__MODULE__{cards: cards}

  @spec deal(t, cards | card) :: t
  def deal(hand, cards) when is_list(cards) do
    %{hand | cards: cards ++ hand.cards}
  end

  def deal(hand, card) do
    deal(hand, [card])
  end

  @spec drop(t, card) :: t
  def drop(hand, card) do
    if card in hand.cards do
      %{hand | cards: List.delete(hand.cards, card)}
    else
      throw("card not found in the hand")
    end
  end

  def update_score(hand, score) do
    %{hand | score: hand.score + score}
  end
end
