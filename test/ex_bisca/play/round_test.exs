defmodule ExBisca.Round.TrickTest do
  use ExUnit.Case

  alias ExBisca.Card
  alias ExBisca.Player
  alias ExBisca.Round.Trick

  @player1 Player.new("player1")
  @player2 Player.new("player2")

  describe "new/2" do
    test "creates a new trick" do
      assert %Trick{} = trick = Trick.new([@player1.id, @player2.id])
      assert trick.stack == [{@player1.id, nil}, {@player2.id, nil}]
      assert trick.current_player_id == @player1.id
    end
  end

  describe "restart/2" do
    test "restarts a trick with new players ordering" do
      trick = Trick.new([@player1.id, @player2.id])

      assert %Trick{} = trick = Trick.restart(trick, @player2.id)
      assert trick.stack == [{@player2.id, nil}, {@player1.id, nil}]
    end
  end

  describe "move/3" do
    setup do
      trick = Trick.new([@player1.id, @player2.id])
      %{trick: trick}
    end

    test "stores a player movement", %{trick: trick} do
      card = Card.new(:spades, :ace)

      assert %Trick{stack: stack} = Trick.move(trick, @player1.id, card)
      assert stack == [{@player1.id, card}, {@player2.id, nil}]
    end

    test "updates the current player as the next player", %{trick: trick} do
      card1 = Card.new(:spades, :ace)
      card2 = Card.new(:spades, :king)

      trick = Trick.move(trick, @player1.id, card1)
      assert trick.current_player_id == @player2.id

      trick = Trick.move(trick, @player2.id, card2)
      assert trick.current_player_id == nil
    end

    test "raises an errors if it's not the player turn", %{trick: trick} do
      card = Card.new(:spades, :ace)

      assert_raise RuntimeError, fn ->
        Trick.move(trick, @player2.id, card)
      end
    end
  end

  describe "winner_id/3" do
    test "returns the ID of the winner player" do
      ace = Card.new(:spades, :ace)
      king = Card.new(:spades, :king)
      trump = Card.new(:hearts, 2)

      trick =
        [@player1.id, @player2.id]
        |> Trick.new()
        |> Trick.move(@player1.id, king)
        |> Trick.move(@player2.id, ace)

      assert @player2.id == Trick.winner_id(trick, trump)
    end
  end

  describe "score/1" do
    test "returns the score of the played cards" do
      ace = Card.new(:spades, :ace)
      king = Card.new(:spades, :king)

      trick =
        [@player1.id, @player2.id]
        |> Trick.new()
        |> Trick.move(@player1.id, king)
        |> Trick.move(@player2.id, ace)

      assert ace.score + king.score == Trick.score(trick)
    end
  end

  describe "complete?/1" do
    test "returns whether all players have played" do
      ace = Card.new(:spades, :ace)
      king = Card.new(:spades, :king)
      trick = Trick.new([@player1.id, @player2.id])

      trick = Trick.move(trick, @player1.id, king)
      refute Trick.complete?(trick)

      trick = Trick.move(trick, @player2.id, ace)
      assert Trick.complete?(trick)
    end
  end
end
