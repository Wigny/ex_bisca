defmodule ExBisca.Play.Card do
  @type rank :: 2 | 3 | 4 | 5 | 6 | 7 | :queen | :jack | :king | :ace
  @type suit :: :spades | :hearts | :diamonds | :clubs
  @type score :: 0 | 2 | 3 | 4 | 10 | 11

  @type t :: %__MODULE__{rank: rank, suit: suit, score: score}

  defstruct [:rank, :suit, :score]

  @spec new(suit, rank) :: t
  def new(suit, rank) when suit in ~w[spades hearts diamonds clubs]a do
    %__MODULE__{suit: suit, rank: rank, score: score(rank)}
  end

  defp score(:ace), do: 11
  defp score(7), do: 10
  defp score(:king), do: 4
  defp score(:jack), do: 3
  defp score(:queen), do: 2
  defp score(rank) when rank in 2..6, do: 0

  @spec captures?(t, t, t) :: boolean
  def captures?(%{score: 0, suit: suit} = card1, %{score: 0, suit: suit} = card2, _trump) do
    card1.rank > card2.rank
  end

  def captures?(%{suit: suit} = card1, %{suit: suit} = card2, _trump) do
    card1.score > card2.score
  end

  def captures?(_card1, card2, trump) do
    card2.suit != trump.suit
  end

  defimpl Inspect do
    def inspect(card, _opts) do
      Inspect.Algebra.concat(["#Card<", rank(card.rank), suit(card.suit), ">"])
    end

    defp rank(:queen), do: "Q"
    defp rank(:jack), do: "J"
    defp rank(:king), do: "K"
    defp rank(:ace), do: "A"
    defp rank(rank), do: to_string(rank)

    defp suit(:spades), do: "\u2660"
    defp suit(:hearts), do: "\u2665"
    defp suit(:diamonds), do: "\u2666"
    defp suit(:clubs), do: "\u2663"
  end
end
