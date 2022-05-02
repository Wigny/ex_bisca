defmodule ExBisca do
  # https://en.wikipedia.org/wiki/Bisca_(card_game)

  @moduledoc """
  ExBisca keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  # def test do
  #   alias ExBisca.Play
  #   alias ExBisca.Play.Deck.Card

  #   play = %Play{
  #     deck: [],
  #     hands: %{
  #       p1: %Play.Hand{
  #         cards: [%Card{rank: 2, suit: :diamonds}, %Card{rank: 5, suit: :hearts}],
  #         score: 70
  #       },
  #       p2: %Play.Hand{
  #         cards: [%Card{rank: 3, suit: :diamonds}, %Card{rank: 2, suit: :hearts}],
  #         score: 50
  #       }
  #     },
  #     round: %Play.Round{current_player: :p1, stack: %{p1: nil, p2: nil}},
  #     trump: %Card{rank: 6, suit: :diamonds}
  #   }

  #   play = Play.move(play, :p1, List.first(play.hands[:p1].cards))
  #   play = Play.move(play, :p2, List.first(play.hands[:p2].cards))
  #   play = Play.move(play, :p2, List.first(play.hands[:p2].cards))
  #   play = Play.move(play, :p1, List.first(play.hands[:p1].cards))

  #   play.round.current_player
  # end

  def test do
    play = ExBisca.Play.start(~w[p1 p2]a)

    play
    |> play()
  end

  defp play(%{round: %{current_player: current_player}, hands: hands} = play) do
    if Enum.empty?(hands[current_player].cards) do
      play
    else
      player = play.round.current_player

      play
      |> ExBisca.Play.move(player, List.first(play.hands[player].cards))
      |> play()
    end
  end
end
