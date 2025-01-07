defmodule ExBisca.Play.Deck do
  alias ExBisca.Play.Deck.Card

  @type t :: list(Card.t())

  @cards for suit <- [:spades, :hearts, :diamonds, :clubs],
             rank <- [2, 3, 4, 5, 6, 7, :queen, :jack, :king, :ace],
             do: Card.new(suit, rank)

  @spec new :: t
  def new, do: Enum.shuffle(@cards)

  @spec take(t, integer) :: {t, t}
  def take(deck, count), do: Enum.split(deck, count)
end
