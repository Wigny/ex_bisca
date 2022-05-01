defmodule ExBisca.Deck do
  alias ExBisca.Deck.Card

  @type t :: list(Card.t())

  @cards for suit <- [:spades, :hearts, :diamonds, :clubs],
             rank <- [2, 3, 4, 5, 6, 7, :queen, :jack, :king, :ace],
             do: %Card{suit: suit, rank: rank}

  def new, do: Enum.shuffle(@cards)

  def take(deck, count \\ 1), do: Enum.split(deck, count)
end
