defmodule ExBisca.Play.Deck.CardTest do
  use ExUnit.Case
  alias ExBisca.Play.Deck.Card

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

  describe "captures?/3 checks if the first card can capture the second" do
    setup do
      %{trump: %Card{rank: 3, suit: :hearts}}
    end

    test "when they are of the same suit", %{trump: trump} do
      assert Card.captures?(
               %Card{rank: 5, suit: :diamonds},
               %Card{rank: 2, suit: :diamonds},
               trump
             )

      assert Card.captures?(
               %Card{rank: :king, suit: :spades},
               %Card{rank: 6, suit: :spades},
               trump
             )

      assert Card.captures?(
               %Card{rank: :ace, suit: :hearts},
               %Card{rank: 7, suit: :hearts},
               trump
             )

      refute Card.captures?(
               %Card{rank: :jack, suit: :clubs},
               %Card{rank: 7, suit: :clubs},
               trump
             )
    end

    test "when they are of different suits and there is no trump between them", %{trump: trump} do
      assert Card.captures?(
               %Card{rank: 2, suit: :diamonds},
               %Card{rank: 3, suit: :clubs},
               trump
             )

      assert Card.captures?(
               %Card{rank: 7, suit: :spades},
               %Card{rank: :ace, suit: :diamonds},
               trump
             )

      assert Card.captures?(
               %Card{rank: :jack, suit: :clubs},
               %Card{rank: :king, suit: :spades},
               trump
             )
    end

    test "when they are of different suits and there is a trump between them", %{trump: trump} do
      assert Card.captures?(
               %Card{rank: 2, suit: trump.suit},
               %Card{rank: 3, suit: :clubs},
               trump
             )

      refute Card.captures?(
               %Card{rank: 7, suit: :spades},
               %Card{rank: 2, suit: trump.suit},
               trump
             )

      assert Card.captures?(
               %Card{rank: 5, suit: trump.suit},
               %Card{rank: 6, suit: :spades},
               trump
             )
    end
  end
end
