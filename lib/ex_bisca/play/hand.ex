defmodule ExBisca.Play.Hand do
  use TypedStruct

  alias ExBisca.Play.Deck.Card

  @typep card :: Card.t()
  @typep cards :: list(card)
  @typep score :: non_neg_integer

  typedstruct opaque: true do
    field :cards, cards
    field :score, score
  end

  @spec new(cards, score) :: t
  def new(cards \\ [], score \\ 0) do
    if length(cards) <= 3 do
      struct!(__MODULE__, cards: cards, score: score)
    else
      raise "A hand must have a maximum of 3 cards at a time, received #{length(cards)}."
    end
  end

  @spec deal_cards(t, cards) :: t
  def deal_cards(hand, cards) do
    new(hand.cards ++ cards, hand.score)
  end

  @spec drop_card(t, card) :: t
  def drop_card(hand, card) do
    if card in hand.cards do
      cards = List.delete(hand.cards, card)
      new(cards, hand.score)
    else
      raise "Card not found in the hand."
    end
  end

  @spec increase_score(t, score) :: t
  def increase_score(hand, score) do
    new(hand.cards, hand.score + score)
  end
end
