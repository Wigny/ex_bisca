defmodule ExBisca.Play.Deck.Card do
  use TypedStruct

  @typep rank :: 2 | 3 | 4 | 5 | 6 | 7 | :queen | :jack | :king | :ace
  @typep suit :: :spades | :hearts | :diamonds | :clubs

  typedstruct do
    field :rank, rank
    field :suit, suit
  end

  @spec new(rank, suit) :: t
  def new(rank, suit), do: struct!(__MODULE__, rank: rank, suit: suit)

  @spec score(t) :: 0 | 2 | 3 | 4 | 10 | 11
  def score(%{rank: :queen}), do: 2
  def score(%{rank: :jack}), do: 3
  def score(%{rank: :king}), do: 4
  def score(%{rank: 7}), do: 10
  def score(%{rank: :ace}), do: 11
  def score(_card), do: 0

  @spec captures?(t, t, t) :: boolean

  def captures?(card1, card2, _trump) when card1.suit == card2.suit do
    card1_score = score(card1)
    card2_score = score(card2)

    if card1_score == 0 and card2_score == 0,
      do: card1.rank > card2.rank,
      else: card1_score > card2_score
  end

  def captures?(_card1, card2, trump) do
    card2.suit != trump.suit
  end

  defimpl Inspect do
    def inspect(card, _opts) do
      Enum.join(["#Card<", rank(card.rank), suit(card.suit), ">"])
    end

    defp rank(:queen), do: "Q"
    defp rank(:jack), do: "J"
    defp rank(:king), do: "K"
    defp rank(:ace), do: "A"
    defp rank(rank), do: rank

    defp suit(:spades), do: "\u2660"
    defp suit(:hearts), do: "\u2665"
    defp suit(:diamonds), do: "\u2666"
    defp suit(:clubs), do: "\u2663"
  end
end
