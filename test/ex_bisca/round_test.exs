defmodule ExBisca.RoundTest do
  use ExUnit.Case

  alias ExBisca.Round
  alias ExBisca.Card
  alias ExBisca.Hand
  alias ExBisca.Player

  @player1 Player.new("player1")
  @player2 Player.new("player2")

  describe "join/2" do
    test "adds a player to a new round" do
      assert %Round{player_ids: player_ids} = Round.join(@player1.id)
      assert player_ids == [@player1.id]
    end

    test "adds a player to an existing round" do
      round = Round.join(@player1.id)

      assert %Round{player_ids: player_ids} = Round.join(round, @player2.id)
      assert player_ids == [@player1.id, @player2.id]
    end
  end

  describe "start/2" do
    setup do
      round = Round.join(@player1.id)
      round = Round.join(round, @player2.id)
      %{round: round}
    end

    test "starts a round", %{round: round} do
      assert %Round{} = round = Round.start(round)
      assert length(round.hands[@player1.id].cards) == 3
      assert length(round.hands[@player2.id].cards) == 3
      assert length(round.deck) == 34
      assert %Card{} = round.trump
    end
  end

  describe "move/2" do
    setup do
      :rand.seed(:exsss, {100, 101, 102})

      round = Round.join(@player1.id)
      round = Round.join(round, @player2.id)

      %{round: Round.start(round)}
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

    test "completes the round after all cards are played", %{round: round} do
      round =
        Enum.reduce(1..40, round, fn _move_num, round ->
          player_id = round.trick.current_player_id

          Round.move(round, player_id, hd(round.hands[player_id].cards))
        end)

      assert Round.complete?(round)
    end
  end

  describe "winner_id/1" do
    setup do
      round = Round.join(@player1.id)
      round = Round.join(round, @player2.id)

      %{round: Round.start(round)}
    end

    test "returns the player with the highest score", %{round: round} do
      round = %{
        round
        | hands: %{
            @player1.id => %ExBisca.Hand{cards: [], score: 68},
            @player2.id => %ExBisca.Hand{cards: [], score: 52}
          }
      }

      assert Round.winner_id(round) == @player1.id
    end

    test "returns nil when there is a draw", %{round: round} do
      round = %{
        round
        | hands: %{
            @player1.id => %ExBisca.Hand{cards: [], score: 60},
            @player2.id => %ExBisca.Hand{cards: [], score: 60}
          }
      }

      assert Round.winner_id(round) == nil
    end
  end
end
