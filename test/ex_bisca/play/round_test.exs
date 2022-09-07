defmodule ExBisca.Play.RoundTest do
  use ExUnit.Case
  alias ExBisca.Play.{Deck, Round, Player}

  describe "move/3" do
    test "makes a player moviment in the round" do
      %{id: player1_id} = Player.new("John")
      %{id: player2_id} = Player.new("Peter")
      {[card], _deck} = Deck.take(Deck.new(), 1)

      round = Round.new([{player1_id, nil}, {player2_id, nil}], player1_id)

      assert %Round{
               stack: [{^player1_id, ^card}, {^player2_id, nil}]
             } = Round.move(round, player1_id, card)
    end

    test "fails when trying to make a card move for a player that is not his turn" do
      %{id: player1_id} = Player.new("John")
      %{id: player2_id} = Player.new("Peter")
      {[card], _deck} = Deck.take(Deck.new(), 1)

      round = Round.new([{player1_id, nil}, {player2_id, nil}], player1_id)

      message = "It's not that player's turn to move."
      assert_raise RuntimeError, message, fn -> Round.move(round, player2_id, card) end
    end
  end

  describe "winner/2" do
    test "finds the winner player of the round" do
      %{id: player1_id} = Player.new("John")
      %{id: player2_id} = Player.new("Peter")
      card1 = Deck.Card.new(2, :spades)
      card2 = Deck.Card.new(2, :hearts)
      trump = Deck.Card.new(6, :hearts)

      round = Round.new([{player1_id, card1}, {player2_id, card2}], player1_id)

      assert player2_id == Round.winner(round, trump)
    end
  end

  describe "next_player/1" do
    test "finds the next player of the round" do
      %{id: player1_id} = Player.new("John")
      %{id: player2_id} = Player.new("Peter")
      {[card1, card2], _deck} = Deck.take(Deck.new(), 2)

      round_1 = Round.new([{player1_id, nil}, {player2_id, nil}], player1_id)
      round_2 = Round.new([{player1_id, card1}, {player2_id, card2}], player2_id)

      assert player2_id == Round.next_player(round_1)
      assert player1_id == Round.next_player(round_2)
    end
  end

  describe "score/1" do
    test "sums the round cards score" do
      player_1 = Player.new("John")
      player_2 = Player.new("Peter")
      card1 = Deck.Card.new(7, :hearts)
      card2 = Deck.Card.new(:ace, :hearts)

      round = Round.new([{player_1.id, card1}, {player_2.id, card2}], player_2.id)

      assert 21 == Round.score(round)
    end
  end

  describe "complete?/1" do
    test "checks if all players have already played this round" do
      player_1 = Player.new("John")
      player_2 = Player.new("Peter")
      {[card1, card2], _deck} = Deck.take(Deck.new(), 2)

      round_1 = Round.new([{player_1.id, card1}, {player_2.id, nil}], player_2.id)
      round_2 = Round.new([{player_1.id, card1}, {player_2.id, card2}], player_2.id)

      refute Round.complete?(round_1)
      assert Round.complete?(round_2)
    end
  end
end
