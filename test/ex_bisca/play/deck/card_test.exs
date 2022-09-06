defmodule ExBisca.Play.Deck.CardTest do
  use ExUnit.Case
  alias ExBisca.Play.Deck.Card

  describe "new/2" do
    test "creates a new card given the rank and suit" do
      assert %Card{rank: :ace, suit: :hearts} = Card.new(:ace, :hearts)
    end
  end

  describe "score/1" do
    test "return ace scores" do
      card = Card.new(:ace, :hearts)
      assert 11 == Card.score(card)
    end

    test "return 7 scores" do
      card = Card.new(7, :hearts)
      assert 10 == Card.score(card)
    end

    test "return king scores" do
      card = Card.new(:king, :hearts)
      assert 4 == Card.score(card)
    end

    test "return jack scores" do
      card = Card.new(:jack, :hearts)
      assert 3 == Card.score(card)
    end

    test "return queen scores" do
      card = Card.new(:queen, :hearts)
      assert 2 == Card.score(card)
    end

    test "returns other cards scores" do
      for rank <- 2..6 do
        card = Card.new(rank, :hearts)
        assert 0 == Card.score(card)
      end
    end
  end

  describe "captures?/3 checks if the first card can capture the second" do
    setup do
      %{trump: Card.new(3, :hearts)}
    end

    test "when they are of the same suit", %{trump: trump} do
      assert Card.captures?(
               Card.new(5, :diamonds),
               Card.new(2, :diamonds),
               trump
             )

      assert Card.captures?(
               Card.new(:king, :spades),
               Card.new(6, :spades),
               trump
             )

      assert Card.captures?(
               Card.new(:ace, :hearts),
               Card.new(7, :hearts),
               trump
             )

      refute Card.captures?(
               Card.new(:jack, :clubs),
               Card.new(7, :clubs),
               trump
             )
    end

    test "when they are of different suits and there is no trump between them", %{trump: trump} do
      assert Card.captures?(
               Card.new(2, :diamonds),
               Card.new(3, :clubs),
               trump
             )

      assert Card.captures?(
               Card.new(7, :spades),
               Card.new(:ace, :diamonds),
               trump
             )

      assert Card.captures?(
               Card.new(:jack, :clubs),
               Card.new(:king, :spades),
               trump
             )
    end

    test "when they are of different suits and there is a trump between them", %{trump: trump} do
      assert Card.captures?(
               Card.new(2, trump.suit),
               Card.new(3, :clubs),
               trump
             )

      refute Card.captures?(
               Card.new(7, :spades),
               Card.new(2, trump.suit),
               trump
             )

      assert Card.captures?(
               Card.new(5, trump.suit),
               Card.new(6, :spades),
               trump
             )
    end
  end
end
