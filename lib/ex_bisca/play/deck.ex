defmodule ExBisca.Deck do
  alias ExBisca.Card

  @type t :: list(Card.t())

  @deck for suit <- [:spades, :hearts, :diamonds, :clubs],
            rank <- [2, 3, 4, 5, 6, 7, :queen, :jack, :king, :ace],
            do: Card.new(suit, rank)

  @spec new :: t
  def new, do: Enum.shuffle(@deck)

  @spec draw(t, integer) :: {t, t}
  def draw(deck, count), do: Enum.split(deck, count)
end
