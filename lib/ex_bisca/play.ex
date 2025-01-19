defmodule ExBisca.Play do
  alias ExBisca.Play.{Card, Deck, Hand, Player, Round}

  @type player :: Player.t()
  @type player_id :: Player.id()
  @type card :: Card.t()
  @type hand :: Hand.t()
  @type deck :: Deck.t()
  @type round :: Round.t()
  @type t :: %__MODULE__{
          deck: deck,
          trump: card,
          player_ids: list(player_id),
          hands: %{player_id => hand},
          round: round
        }

  defstruct [:deck, :trump, :round, :player_ids, :hands]

  @spec start(player_ids :: list(player_id)) :: t
  def start(player_ids) do
    deck = Deck.new()
    hands = Map.from_keys(player_ids, Hand.new())

    %__MODULE__{deck: deck, player_ids: player_ids, hands: hands}
    |> deal_players_cards(3)
    |> turn_up_trump()
    |> start_first_round()
  end

  defp deal_players_cards(play, count) do
    Enum.reduce(play.hands, play, fn {player_id, hand}, play ->
      {cards, deck} = Deck.draw(play.deck, count)

      %{play | deck: deck, hands: %{play.hands | player_id => Hand.deal(hand, cards)}}
    end)
  end

  defp turn_up_trump(play) do
    trump = List.last(play.deck)

    %{play | trump: trump}
  end

  defp start_first_round(play) do
    %{play | round: Round.new(play.player_ids)}
  end

  @spec move(play :: t, player_id, card) :: t
  def move(play, player_id, card) do
    play
    |> move_player_card(player_id, card)
    |> prepare_next_move()
  end

  defp move_player_card(play, player_id, card) do
    hand = Hand.drop(play.hands[player_id], card)
    round = Round.move(play.round, player_id, card)

    %{play | hands: %{play.hands | player_id => hand}, round: round}
  end

  defp prepare_next_move(play) do
    if Round.complete?(play.round) do
      prepare_next_round(play)
    else
      play
    end
  end

  defp prepare_next_round(play) do
    round_winner_id = Round.winner_id(play.round, play.trump)
    round_score = Round.score(play.round)

    winner_hand = Hand.increase_score(play.hands[round_winner_id], round_score)

    round = Round.restart(play.round, round_winner_id)
    hands = %{play.hands | round_winner_id => winner_hand}

    deal_players_cards(%{play | round: round, hands: hands}, 1)
  end
end
