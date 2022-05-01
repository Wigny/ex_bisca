defmodule ExBisca.Deck.CardTest do
  use ExUnit.Case
  alias ExBisca.Deck.Card

  describe "score/1" do
    test "return ace scores" do
      assert 11 == Card.score(%Card{rank: :ace, suit: :hearts})
    end

    test "return 7 scores" do
      assert 10 == Card.score(%Card{rank: 7, suit: :hearts})
    end

    test "return king scores" do
      assert 4 == Card.score(%Card{rank: :king, suit: :hearts})
    end

    test "return jack scores" do
      assert 3 == Card.score(%Card{rank: :jack, suit: :hearts})
    end

    test "return queen scores" do
      assert 2 == Card.score(%Card{rank: :queen, suit: :hearts})
    end

    test "returns other cards scores" do
      for rank <- 2..6 do
        assert 0 == Card.score(%Card{rank: rank, suit: :hearts})
      end
    end
  end

  describe "gt?/3 checks if the first card is greater than the second" do
    setup do
      %{trump: %Card{rank: 3, suit: :hearts}}
    end

    test "if they are of the same suit", %{trump: trump} do
      assert Card.gt?(%Card{rank: 5, suit: :diamonds}, %Card{rank: 2, suit: :diamonds}, trump)
      assert Card.gt?(%Card{rank: :king, suit: :spades}, %Card{rank: 6, suit: :spades}, trump)
      assert Card.gt?(%Card{rank: :ace, suit: :hearts}, %Card{rank: 7, suit: :hearts}, trump)
      refute Card.gt?(%Card{rank: :jack, suit: :clubs}, %Card{rank: 7, suit: :clubs}, trump)
    end

    test "if they are of different suits and there is no trump card between them", %{trump: trump} do
      assert Card.gt?(%Card{rank: 2, suit: :diamonds}, %Card{rank: 3, suit: :clubs}, trump)
      assert Card.gt?(%Card{rank: 7, suit: :spades}, %Card{rank: :ace, suit: :diamonds}, trump)
      assert Card.gt?(%Card{rank: :jack, suit: :clubs}, %Card{rank: :king, suit: :spades}, trump)
    end

    test "if they are of different suits and there is a trump card between them", %{trump: trump} do
      assert Card.gt?(%Card{rank: 2, suit: trump.suit}, %Card{rank: 3, suit: :clubs}, trump)
      refute Card.gt?(%Card{rank: 7, suit: :spades}, %Card{rank: 2, suit: trump.suit}, trump)
      assert Card.gt?(%Card{rank: 5, suit: trump.suit}, %Card{rank: 6, suit: :spades}, trump)
    end
  end
end
