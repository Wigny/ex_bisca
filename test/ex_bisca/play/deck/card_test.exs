defmodule ExBisca.Play.Deck.CardTest do
  use ExUnit.Case
  alias ExBisca.Play.Deck.Card

  describe "captures?/3 checks if the first card can capture the second" do
    setup do
      %{trump: Card.new(:hearts, 3)}
    end

    test "when they are of the same suit", %{trump: trump} do
      assert Card.captures?(Card.new(:diamonds, 5), Card.new(:diamonds, 2), trump)
      assert Card.captures?(Card.new(:spades, :king), Card.new(:spades, 6), trump)
      assert Card.captures?(Card.new(:hearts, :ace), Card.new(:hearts, 7), trump)
      refute Card.captures?(Card.new(:clubs, :jack), Card.new(:clubs, 7), trump)
    end

    test "when they are of different suits and there is no trump between them", %{trump: trump} do
      assert Card.captures?(Card.new(:diamonds, 2), Card.new(:clubs, 3), trump)
      assert Card.captures?(Card.new(:spades, 7), Card.new(:diamonds, :ace), trump)
      assert Card.captures?(Card.new(:clubs, :jack), Card.new(:spades, :king), trump)
    end

    test "when they are of different suits and there is a trump between them", %{trump: trump} do
      assert Card.captures?(Card.new(trump.suit, 2), Card.new(:clubs, 3), trump)
      refute Card.captures?(Card.new(:spades, 7), Card.new(trump.suit, 2), trump)
      assert Card.captures?(Card.new(trump.suit, 5), Card.new(:spades, 6), trump)
    end
  end
end
