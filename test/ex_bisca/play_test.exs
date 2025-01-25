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
    setup do
      :rand.seed(:exsss, {100, 101, 102})

      %{play: Play.start([@player1.id, @player2.id])}
    end

    test "moves card from player's hand", %{play: play} do
      card = List.first(play.hands[@player1.id].cards)

      assert %Play{} = play = Play.move(play, @player1.id, card)
      assert length(play.hands[@player1.id].cards) == 2
      assert play.round.stack == [{@player1.id, card}, {@player2.id, nil}]
    end

    test "increases score of the round' winner", %{play: play} do
      play =
        play
        |> Play.move(@player1.id, hd(play.hands[@player1.id].cards))
        |> Play.move(@player2.id, hd(play.hands[@player2.id].cards))

      assert %Hand{score: 12} = play.hands[@player1.id]
      assert %Hand{score: 0} = play.hands[@player2.id]
    end

    test "deal a card to each player on the end of the round", %{play: play} do
      play =
        play
        |> Play.move(@player1.id, hd(play.hands[@player1.id].cards))
        |> Play.move(@player2.id, hd(play.hands[@player2.id].cards))

      assert length(play.hands[@player1.id].cards) == 3
      assert length(play.hands[@player2.id].cards) == 3
    end

    test "starts a new round starting by the last round' winner", %{play: play} do
      play =
        play
        |> Play.move(@player1.id, hd(play.hands[@player1.id].cards))
        |> Play.move(@player2.id, hd(play.hands[@player2.id].cards))

      assert play.round.current_player_id == @player1.id
    end
  end
end
