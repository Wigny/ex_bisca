defmodule ExBisca.PlayTest do
  use ExUnit.Case
  alias ExBisca.Play
  alias ExBisca.Play.Deck.Card

  test "start/2" do
    assert %Play{
             deck: deck,
             hands: %{
               player_1: %Play.Hand{cards: player_1_cards, score: 0},
               player_2: %Play.Hand{cards: player_2_cards, score: 0}
             },
             round: %Play.Round{
               current_player: :player_1,
               stack: %{player_1: nil, player_2: nil}
             },
             trump: _trump
           } = Play.start([:player_1, :player_2])

    assert length(deck) == 34
    assert length(player_1_cards) == 3
    assert length(player_2_cards) == 3
  end

  describe "move/2" do
    setup do
      play = %Play{
        deck: [
          %Card{rank: 7, suit: :clubs},
          %Card{rank: 5, suit: :diamonds},
          %Card{rank: 6, suit: :hearts},
          %Card{rank: :king, suit: :spades},
          %Card{rank: 5, suit: :hearts},
          %Card{rank: :jack, suit: :hearts},
          %Card{rank: :queen, suit: :hearts},
          %Card{rank: 2, suit: :diamonds},
          %Card{rank: 7, suit: :spades},
          %Card{rank: :ace, suit: :clubs},
          %Card{rank: 6, suit: :clubs},
          %Card{rank: 4, suit: :hearts},
          %Card{rank: 6, suit: :diamonds},
          %Card{rank: 3, suit: :spades},
          %Card{rank: 4, suit: :spades},
          %Card{rank: 3, suit: :diamonds},
          %Card{rank: 6, suit: :spades},
          %Card{rank: 7, suit: :hearts},
          %Card{rank: :queen, suit: :spades},
          %Card{rank: :ace, suit: :spades},
          %Card{rank: 7, suit: :diamonds},
          %Card{rank: :queen, suit: :diamonds},
          %Card{rank: :jack, suit: :diamonds},
          %Card{rank: 2, suit: :spades},
          %Card{rank: 3, suit: :hearts},
          %Card{rank: :king, suit: :hearts},
          %Card{rank: :ace, suit: :hearts},
          %Card{rank: :jack, suit: :spades},
          %Card{rank: :queen, suit: :clubs},
          %Card{rank: 5, suit: :spades},
          %Card{rank: :king, suit: :diamonds},
          %Card{rank: 3, suit: :clubs},
          %Card{rank: 4, suit: :clubs}
        ],
        hands: %{
          player_1: %Play.Hand{
            cards: [
              %Card{rank: :king, suit: :clubs},
              %Card{rank: 2, suit: :hearts},
              %Card{rank: 4, suit: :diamonds}
            ],
            score: 0
          },
          player_2: %Play.Hand{
            cards: [
              %Card{rank: 2, suit: :clubs},
              %Card{rank: 5, suit: :clubs},
              %Card{rank: :jack, suit: :clubs}
            ],
            score: 0
          }
        },
        round: %ExBisca.Play.Round{
          current_player: :player_1,
          stack: %{player_1: nil, player_2: nil}
        },
        trump: %Card{rank: :ace, suit: :diamonds}
      }

      %{play: play}
    end

    test "moves player card and prepare next move", %{play: play} do
      assert %Play{
               hands: %{
                 player_1: %Play.Hand{score: 0}
               },
               round: %ExBisca.Play.Round{
                 current_player: :player_2,
                 stack: %{player_1: %Card{rank: :king, suit: :clubs}, player_2: nil}
               }
             } = Play.move(play, :player_1, %Card{rank: :king, suit: :clubs})
    end

    test "moves player card and prepare next round", %{play: play} do
      play = Play.move(play, :player_1, %Card{rank: :king, suit: :clubs})

      assert %Play{
               hands: %{
                 player_1: %Play.Hand{score: 4},
                 player_2: %Play.Hand{score: 0}
               },
               round: %ExBisca.Play.Round{
                 current_player: :player_1,
                 stack: %{player_1: nil, player_2: nil}
               }
             } = Play.move(play, :player_2, %Card{rank: 2, suit: :clubs})
    end

    test "deals cards until finish deck", %{play: play} do
      play = %{
        play
        | deck: [],
          hands: %{
            player_1: %Play.Hand{
              cards: [
                %Card{rank: :king, suit: :clubs}
              ],
              score: 58
            },
            player_2: %Play.Hand{
              cards: [
                %Card{rank: 2, suit: :clubs}
              ],
              score: 58
            }
          }
      }

      play = Play.move(play, :player_1, %Card{rank: :king, suit: :clubs})

      assert %Play{
               deck: [],
               hands: %{
                 player_1: %Play.Hand{cards: [], score: 62},
                 player_2: %Play.Hand{cards: [], score: 58}
               }
             } = Play.move(play, :player_2, %Card{rank: 2, suit: :clubs})
    end
  end
end
