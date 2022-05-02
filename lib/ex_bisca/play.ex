defmodule ExBisca.Play do
  use TypedStruct

  alias __MODULE__.{Deck, Hand, Player, Round}

  @type player_id :: Player.id()
  @type card :: Deck.Card.t()
  @type hand :: Hand.t()
  @type deck :: Deck.t()
  @type round :: Round.t()

  typedstruct opaque: true do
    field :deck, deck
    field :trump, card
    field :hands, %{player_id => hand}, default: %{}
    field :round, round
  end

  @spec start(player_ids :: list(player_id)) :: t
  def start(player_ids) do
    deck = Deck.new()
    hands = Map.new(player_ids, &{&1, Hand.new()})

    %__MODULE__{deck: deck, hands: hands}
    |> deal_players_cards(3)
    |> turn_up_trump()
    |> start_first_round()
  end

  @spec move(t, player_id, card) :: t
  def move(play, player_id, card) do
    play
    |> move_player_card(player_id, card)
    |> prepare_next_move()
  end

  defp deal_players_cards(play, count) do
    Enum.reduce(play.hands, play, fn {player_id, hand}, acc ->
      {cards, deck} = Deck.take(acc.deck, count)

      %{acc | deck: deck, hands: %{acc.hands | player_id => Hand.deal(hand, cards)}}
    end)
  end

  defp turn_up_trump(play) do
    trump = List.last(play.deck)

    %{play | trump: trump}
  end

  defp start_first_round(play) do
    players = Map.keys(play.hands)
    first_player = List.first(players)

    %{play | round: Round.start(players, first_player)}
  end

  defp move_player_card(play, player, card) do
    hand = Hand.drop(play.hands[player], card)
    round = Round.move(play.round, player, card)

    %{play | hands: %{play.hands | player => hand}, round: round}
  end

  defp prepare_next_move(play) do
    round_incomplete? = Enum.any?(play.round.stack, &match?({_player, nil}, &1))

    if round_incomplete?, do: prepare_next_round_move(play), else: prepare_next_round(play)
  end

  defp prepare_next_round_move(play) do
    round = %{play.round | current_player: Round.next_player(play.round)}

    %{play | round: round}
  end

  defp prepare_next_round(play) do
    round_winner = Round.winner(play.round, play.trump)
    round_score = Round.score(play.round)

    winner_hand = Hand.update_score(play.hands[round_winner], round_score)

    round = Round.restart(play.round, round_winner)
    hands = %{play.hands | round_winner => winner_hand}

    deal_players_cards(%{play | round: round, hands: hands}, 1)
  end
end
