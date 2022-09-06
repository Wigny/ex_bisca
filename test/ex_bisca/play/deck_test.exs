defmodule ExBisca.Play.DeckTest do
  use ExUnit.Case
  alias ExBisca.Play.Deck

  describe "new/2" do
    test "creates a new cards deck" do
      deck = Deck.new()

      assert 40 == length(deck)
    end
  end

  describe "take/2" do
    test "takes cards from the deck given the amount" do
      deck = Deck.new()

      assert {cards, new_deck} = Deck.take(deck, 3)
      assert 3 == length(cards)
      assert 37 == length(new_deck)
    end
  end
end
