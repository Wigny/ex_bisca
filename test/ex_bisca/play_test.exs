defmodule ExBisca.RoundTest do
  use ExUnit.Case

  alias ExBisca.Round
  alias ExBisca.Card
  alias ExBisca.Hand
  alias ExBisca.Player

  @player1 Player.new("player1")
  @player2 Player.new("player2")

  describe "start/2" do
    test "setup a new round" do
      assert %Round{} = round = Round.start([@player1.id, @player2.id])
      assert length(round.hands[@player1.id].cards) == 3
      assert length(round.hands[@player2.id].cards) == 3
      assert length(round.deck) == 34
      assert %Card{} = round.trump
    end
  end

  describe "move/2" do
    setup do
      :rand.seed(:exsss, {100, 101, 102})

      %{round: Round.start([@player1.id, @player2.id])}
    end

    test "moves card from player's hand", %{round: round} do
      card = List.first(round.hands[@player1.id].cards)

      assert %Round{} = round = Round.move(round, @player1.id, card)
      assert length(round.hands[@player1.id].cards) == 2
      assert round.trick.stack == [{@player1.id, card}, {@player2.id, nil}]
    end

    test "increases score of the trick winner", %{round: round} do
      round =
        round
        |> Round.move(@player1.id, hd(round.hands[@player1.id].cards))
        |> Round.move(@player2.id, hd(round.hands[@player2.id].cards))

      assert %Hand{score: 12} = round.hands[@player1.id]
      assert %Hand{score: 0} = round.hands[@player2.id]
    end

    test "deal a card to each player on the end of the trick", %{round: round} do
      round =
        round
        |> Round.move(@player1.id, hd(round.hands[@player1.id].cards))
        |> Round.move(@player2.id, hd(round.hands[@player2.id].cards))

      assert length(round.hands[@player1.id].cards) == 3
      assert length(round.hands[@player2.id].cards) == 3
    end

    test "starts a new trick starting by the last trick winner", %{round: round} do
      round =
        round
        |> Round.move(@player1.id, hd(round.hands[@player1.id].cards))
        |> Round.move(@player2.id, hd(round.hands[@player2.id].cards))

      assert round.trick.current_player_id == @player1.id
    end
  end
end
