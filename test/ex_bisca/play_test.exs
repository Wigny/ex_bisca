defmodule ExBisca.PlayTest do
  use ExUnit.Case
  alias ExBisca.Play
  alias ExBisca.Play.Card
  alias ExBisca.Play.Hand
  alias ExBisca.Play.Player

  @player1 Player.new("player1")
  @player2 Player.new("player2")

  describe "start/2" do
    test "setup a new play" do
      assert %Play{} = play = Play.start([@player1.id, @player2.id])
      assert length(play.hands[@player1.id].cards) == 3
      assert length(play.hands[@player2.id].cards) == 3
      assert length(play.deck) == 34
      assert %Card{} = play.trump
    end
  end

  describe "move/2" do
    test "moves card from player's hand" do
      play = Play.start([@player1.id, @player2.id])
      card = List.first(play.hands[@player1.id].cards)

      assert %Play{} = play = Play.move(play, @player1.id, card)
      assert length(play.hands[@player1.id].cards) == 2
      assert play.round.stack[@player1.id] == card
    end

    test "increases score of the round' winner" do
      :rand.seed(:exsss, {100, 101, 102})

      IO.inspect(@player1.id, label: :player1)
      IO.inspect(@player2.id, label: :player2)

      play = Play.start([@player1.id, @player2.id])

      play =
        play
        |> Play.move(@player1.id, hd(play.hands[@player1.id].cards))
        |> Play.move(@player2.id, hd(play.hands[@player2.id].cards))
        |> IO.inspect()

      assert %Hand{score: 12} = play.hands[@player1.id]
      assert %Hand{score: 0} = play.hands[@player2.id]
    end
  end
end
