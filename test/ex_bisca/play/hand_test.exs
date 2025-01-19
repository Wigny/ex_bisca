defmodule ExBisca.Play.HandTest do
  use ExUnit.Case
  alias ExBisca.Play.Hand

  @deck ExBisca.Play.Deck.new()

  describe "add/2" do
    test "adds cards to a hand" do
      cards_drawn = Enum.take(@deck, 3)

      hand = Hand.new()
      assert %Hand{cards: cards} = Hand.deal(hand, cards_drawn)
      assert length(cards) == 3
    end

    test "raises an error if the number of cards exceeds" do
      hand = Hand.new(Enum.slice(@deck, 0..2))
      cards_drawn = Enum.slice(@deck, 3..5)

      assert_raise RuntimeError, fn ->
        Hand.deal(hand, cards_drawn)
      end
    end
  end

  describe "drop/2" do
    test "removes a card from the hand" do
      [first_card | remaining_cards] = cards = Enum.take(@deck, 3)

      hand = Hand.new(cards)
      assert %Hand{cards: ^remaining_cards} = Hand.drop(hand, first_card)
    end

    test "fails if the card is not in the hand" do
      {cards, deck} = Enum.split(@deck, 3)
      card = Enum.random(deck)

      assert_raise RuntimeError, fn ->
        Hand.drop(Hand.new(cards), card)
      end
    end
  end
end
