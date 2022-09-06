defmodule ExBisca.Play.HandTest do
  use ExUnit.Case
  alias ExBisca.Play.{Deck, Hand}

  describe "new/2" do
    test "creates a new players hand" do
      {cards, _deck} = Deck.take(Deck.new(), 3)

      assert %Hand{cards: ^cards, score: 0} = Hand.new(cards)
    end

    test "fails when trying to create a hand with more then 3 cards" do
      {cards, _deck} = Deck.take(Deck.new(), 4)

      message = ~r/^A hand must have a maximum of 3 cards at a time, received \d+.$/
      assert_raise RuntimeError, message, fn -> Hand.new(cards) end
    end
  end

  describe "deal/2" do
    setup do
      {cards, deck} = Deck.take(Deck.new(), 2)

      %{hand: Hand.new(cards), deck: deck}
    end

    test "deals given cards to a hand", %{hand: hand, deck: deck} do
      {cards, _deck} = Deck.take(deck, 1)

      new_hand = Hand.deal_cards(hand, cards)
      refute hand.cards == new_hand.cards
      assert hand.score == new_hand.score
    end
  end

  describe "drop/2" do
    setup do
      {cards, deck} = Deck.take(Deck.new(), 3)

      %{hand: Hand.new(cards), deck: deck}
    end

    test "drops given card of a hand", %{hand: hand} do
      new_hand = Hand.drop_card(hand, hd(hand.cards))
      refute hand.cards == new_hand.cards
      assert hand.score == new_hand.score
    end

    test "fails when trying to drop a inexistent hands card", %{hand: hand, deck: deck} do
      message = "Card not found in the hand."
      assert_raise RuntimeError, message, fn -> Hand.drop_card(hand, hd(deck)) end
    end
  end

  describe "increase_score/2" do
    setup do
      {cards, _deck} = Deck.take(Deck.new(), 3)

      %{hand: Hand.new(cards)}
    end

    test "sum given score with the hands current score", %{hand: hand} do
      new_hand = Hand.increase_score(hand, 10)
      refute hand.score == new_hand.score
      assert hand.cards == new_hand.cards
    end
  end
end
