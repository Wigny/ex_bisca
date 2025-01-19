defmodule ExBisca.PlayTest do
  use ExUnit.Case
  alias ExBisca.Play
  alias ExBisca.Play.Card
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

  # describe "move/2" do
  #   setup do
  #     play = %Play{
  #       deck: [
  #         Card.new(:clubs, 7),
  #         Card.new(:diamonds, 5),
  #         Card.new(:hearts, 6),
  #         Card.new(:spades, :king),
  #         Card.new(:hearts, 5),
  #         Card.new(:hearts, :jack),
  #         Card.new(:hearts, :queen),
  #         Card.new(:diamonds, 2),
  #         Card.new(:spades, 7),
  #         Card.new(:clubs, :ace),
  #         Card.new(:clubs, 6),
  #         Card.new(:hearts, 4),
  #         Card.new(:diamonds, 6),
  #         Card.new(:spades, 3),
  #         Card.new(:spades, 4),
  #         Card.new(:diamonds, 3),
  #         Card.new(:spades, 6),
  #         Card.new(:hearts, 7),
  #         Card.new(:spades, :queen),
  #         Card.new(:spades, :ace),
  #         Card.new(:diamonds, 7),
  #         Card.new(:diamonds, :queen),
  #         Card.new(:diamonds, :jack),
  #         Card.new(:spades, 2),
  #         Card.new(:hearts, 3),
  #         Card.new(:hearts, :king),
  #         Card.new(:hearts, :ace),
  #         Card.new(:spades, :jack),
  #         Card.new(:clubs, :queen),
  #         Card.new(:spades, 5),
  #         Card.new(:diamonds, :king),
  #         Card.new(:clubs, 3),
  #         Card.new(:clubs, 4)
  #       ],
  #       hands: %{
  #         player_1: %Play.Hand{
  #           cards: [
  #             Card.new(:clubs, :king),
  #             Card.new(:hearts, 2),
  #             Card.new(:diamonds, 4)
  #           ],
  #           score: 0
  #         },
  #         player_2: %Play.Hand{
  #           cards: [
  #             Card.new(:clubs, 2),
  #             Card.new(:clubs, 5),
  #             Card.new(:clubs, :jack)
  #           ],
  #           score: 0
  #         }
  #       },
  #       round: %ExBisca.Play.Round{
  #         stack: [player_1: nil, player_2: nil]
  #       },
  #       trump: Card.new(:diamonds, :ace)
  #     }

  #     %{play: play}
  #   end

  #   test "moves player card and prepare next move", %{play: play} do
  #     assert %Play{
  #              hands: %{
  #                player_1: %Play.Hand{score: 0}
  #              },
  #              round: %ExBisca.Play.Round{
  #                stack: [player_1: Card.new(:clubs, :king), player_2: nil]
  #              }
  #            } = Play.move(play, :player_1, Card.new(:clubs, :king))
  #   end

  #   test "moves player card and prepare next round", %{play: play} do
  #     play = Play.move(play, :player_1, Card.new(:clubs, :king))

  #     assert %Play{
  #              hands: %{
  #                player_1: %Play.Hand{score: 4},
  #                player_2: %Play.Hand{score: 0}
  #              },
  #              round: %ExBisca.Play.Round{
  #                stack: [player_1: nil, player_2: nil]
  #              }
  #            } = Play.move(play, :player_2, Card.new(:clubs, 2))
  #   end

  #   test "deals cards until finish deck", %{play: play} do
  #     play = %{
  #       play
  #       | deck: [],
  #         hands: %{
  #           player_1: %Play.Hand{
  #             cards: [
  #               Card.new(:clubs, :king)
  #             ],
  #             score: 58
  #           },
  #           player_2: %Play.Hand{
  #             cards: [
  #               Card.new(:clubs, 2)
  #             ],
  #             score: 58
  #           }
  #         }
  #     }

  #     play = Play.move(play, :player_1, Card.new(:clubs, :king))

  #     assert %Play{
  #              deck: [],
  #              hands: %{
  #                player_1: %Play.Hand{cards: [], score: 62},
  #                player_2: %Play.Hand{cards: [], score: 58}
  #              }
  #            } = Play.move(play, :player_2, Card.new(:clubs, 2))
  #   end
  # end
end
