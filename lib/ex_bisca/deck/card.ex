defmodule ExBisca.Deck.Card do
  use TypedStruct

  defguard is_trump(trump, card) when card.suit == trump.suit

  typedstruct enforce: true do
    field :rank, 2 | 3 | 4 | 5 | 6 | 7 | :queen | :jack | :king | :ace
    field :suit, :spades | :hearts | :diamonds | :clubs
  end

  @spec score(t) :: 0 | 2 | 3 | 4 | 10 | 11
  def score(%{rank: :queen}), do: 2
  def score(%{rank: :jack}), do: 3
  def score(%{rank: :king}), do: 4
  def score(%{rank: 7}), do: 10
  def score(%{rank: :ace}), do: 11
  def score(_card), do: 0

  @spec gt?(t, t, t) :: boolean
  def gt?(card1, card2, _trump) when card1.suit == card2.suit do
    card1_score = score(card1)
    card2_score = score(card2)

    if Enum.all?([card1_score, card2_score], fn p -> p == 0 end) do
      card1.rank > card2.rank
    else
      card1_score > card2_score
    end
  end

  def gt?(card1, card2, trump) when not is_trump(trump, card1) and not is_trump(trump, card2) do
    true
  end

  def gt?(card1, _card2, trump) do
    is_trump(trump, card1)
  end

  defimpl Inspect do
    def inspect(card, _opts) do
      Enum.join(["#Card<", card.rank, suit(card.suit), ">"])
    end

    defp suit(:spades), do: "\u2660"
    defp suit(:hearts), do: "\u2665"
    defp suit(:diamonds), do: "\u2666"
    defp suit(:clubs), do: "\u2663"
  end
end
