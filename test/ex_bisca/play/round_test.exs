defmodule ExBisca.Play.RoundTest do
  use ExUnit.Case

  alias ExBisca.Play.Card
  alias ExBisca.Play.Player
  alias ExBisca.Play.Round

  @player1 Player.new("player1")
  @player2 Player.new("player2")

  describe "new/2" do
    test "creates a new round" do
      assert %Round{} = round = Round.new([@player1.id, @player2.id])
      assert round.stack == %{@player1.id => nil, @player2.id => nil}
      assert round.current_player_id == @player1.id
    end
  end

  describe "restart/2" do
    test "restarts a round with new players ordering" do
      round = Round.new([@player1.id, @player2.id])

      assert %Round{} = round = Round.restart(round, @player2.id)
      assert round.stack == %{@player1.id => nil, @player2.id => nil}
      assert round.current_player_id == @player2.id
    end
  end

  describe "move/3" do
    setup do
      round = Round.new([@player1.id, @player2.id])
      %{round: round}
    end

    test "stores a player movement", %{round: round} do
      card = Card.new(:spades, :ace)

      assert %Round{stack: stack} = Round.move(round, @player1.id, card)
      assert stack == %{@player1.id => card, @player2.id => nil}
    end

    test "updates the current player as the next player", %{round: round} do
      card1 = Card.new(:spades, :ace)
      card2 = Card.new(:spades, :king)

      round = Round.move(round, @player1.id, card1)
      assert round.current_player_id == @player2.id

      round = Round.move(round, @player2.id, card2)
      assert round.current_player_id == nil
    end

    test "raises an errors if it's not the player turn", %{round: round} do
      card = Card.new(:spades, :ace)

      assert_raise RuntimeError, fn ->
        Round.move(round, @player2.id, card)
      end
    end
  end

  describe "winner_id/3" do
    test "returns the ID of the winner player" do
      ace = Card.new(:spades, :ace)
      king = Card.new(:spades, :king)
      trump = Card.new(:hearts, 2)

      round =
        [@player1.id, @player2.id]
        |> Round.new()
        |> Round.move(@player1.id, king)
        |> Round.move(@player2.id, ace)

      assert @player2.id == Round.winner_id(round, trump)
    end
  end

  describe "score/1" do
    test "returns the score of the played cards" do
      ace = Card.new(:spades, :ace)
      king = Card.new(:spades, :king)

      round =
        [@player1.id, @player2.id]
        |> Round.new()
        |> Round.move(@player1.id, king)
        |> Round.move(@player2.id, ace)

      assert ace.score + king.score == Round.score(round)
    end
  end

  describe "complete?/1" do
    test "returns whether all players have played" do
      ace = Card.new(:spades, :ace)
      king = Card.new(:spades, :king)
      round = Round.new([@player1.id, @player2.id])

      round = Round.move(round, @player1.id, king)
      refute Round.complete?(round)

      round = Round.move(round, @player2.id, ace)
      assert Round.complete?(round)
    end
  end
end
