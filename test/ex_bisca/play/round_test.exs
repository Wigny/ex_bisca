defmodule ExBisca.Play.RoundTest do
  use ExUnit.Case
  alias ExBisca.Play.{Deck, Round, Player}

  setup do
    players = for name <- ~w[John Peter], do: Player.new(name)
    {cards, _deck} = Deck.take(Deck.new(), 2)

    %{players: players, cards: cards}
  end

  describe "start/2" do
    test "starts a new round", setup do
      %{players: [player1, player2]} = setup

      round = Round.new([{player1.id, nil}, {player2.id, nil}], player1.id)

      assert round == Round.start([player1.id, player2.id], player1.id)
    end
  end

  describe "restart/2" do
    test "restarts a existing round", setup do
      %{players: [player1, player2], cards: [card1, card2]} = setup

      round1 = Round.new([{player1.id, card1}, {player2.id, card2}], player1.id)
      round2 = Round.new([{player2.id, nil}, {player1.id, nil}], player2.id)

      assert round2 == Round.restart(round1, player2.id)
    end
  end

  describe "move/3" do
    test "makes a player moviment in the round", setup do
      %{players: [player1, player2], cards: [card1 | _]} = setup

      round_move1 = Round.new([{player1.id, nil}, {player2.id, nil}], player1.id)
      round_move2 = Round.new([{player1.id, card1}, {player2.id, nil}], player1.id)

      assert round_move2 == Round.move(round_move1, player1.id, card1)
    end

    test "fails when trying to make a card move for a player that is not his turn", setup do
      %{players: [player1, player2], cards: [card | _]} = setup

      round = Round.new([{player1.id, nil}, {player2.id, nil}], player1.id)

      message = "It's not that player's turn to move."
      assert_raise RuntimeError, message, fn -> Round.move(round, player2.id, card) end
    end
  end

  describe "winner/2" do
    test "finds the winner player of the round", setup do
      %{players: [player1, player2], cards: [card1, trump]} = setup

      round = Round.new([{player1.id, card1}, {player2.id, trump}], player1.id)

      assert player2.id == Round.winner(round, trump)
    end
  end

  describe "next_player/1" do
    test "finds the next player of the round", setup do
      %{players: [player1, player2], cards: [card1, card2]} = setup

      round1 = Round.new([{player1.id, nil}, {player2.id, nil}], player1.id)
      round2 = Round.new([{player1.id, card1}, {player2.id, card2}], player2.id)

      assert player2.id == Round.next_player(round1)
      assert player1.id == Round.next_player(round2)
    end
  end

  describe "score/1" do
    test "sums the round cards score", setup do
      %{players: [player1, player2], cards: [card1, card2] = cards} = setup

      round = Round.new([{player1.id, card1}, {player2.id, card2}], player2.id)

      assert cards
             |> Enum.map(&Deck.Card.score/1)
             |> Enum.sum() == Round.score(round)
    end
  end

  describe "complete?/1" do
    test "checks if all players have already played this round", setup do
      %{players: [player1, player2], cards: [card1, card2]} = setup

      round1 = Round.new([{player1.id, card1}, {player2.id, nil}], player2.id)
      round2 = Round.new([{player1.id, card1}, {player2.id, card2}], player2.id)

      refute Round.complete?(round1)
      assert Round.complete?(round2)
    end
  end
end
