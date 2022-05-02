defmodule ExBisca.Play do
  use TypedStruct

  alias __MODULE__.{Deck, Hand, Round}

  @type player_id :: atom
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

  @spec start(player_ids :: list(player_id)) :: t()
  def start(player_ids) do
    deck = Deck.new()
    hands = Map.new(player_ids, &{&1, Hand.new()})

    %__MODULE__{deck: deck, hands: hands}
    |> deals_cards(3)
    |> turn_up_trump()
    |> start_first_round()
  end

  def move(play, player, card) do
    hand = Hand.drop(play.hands[player], card)
    round = Round.move(play.round, player, card)

    if Enum.any?(round.stack, &match?({_player, nil}, &1)),
      do: next_round_move(play, round, {player, hand}),
      else: next_round(play, round, {player, hand})
  end

  defp deals_cards(play, count) do
    Enum.reduce(play.hands, play, fn {player_id, hand}, acc ->
      {cards, deck} = Deck.take(acc.deck, count)

      %{acc | deck: deck, hands: %{acc.hands | player_id => Hand.deal(hand, cards)}}
    end)
  end

  defp turn_up_trump(play) do
    {[trump], deck} = Deck.take(play.deck)

    %{play | deck: deck, trump: trump}
  end

  defp start_first_round(play) do
    players = Map.keys(play.hands)
    first_player = List.first(players)

    %{play | round: Round.start(players, first_player)}
  end

  defp next_round_move(play, round, {player, hand}) do
    round = %{round | current_player: Round.next_player(round)}
    hands = %{play.hands | player => hand}

    %{play | round: round, hands: hands}
  end

  defp next_round(play, round, {player, hand}) do
    round_winner = Round.winner(round, play.trump)
    round_score = Round.score(round)

    winner_hand = Hand.update_score(play.hands[round_winner], round_score)

    round = Round.restart(round, round_winner)
    hands = %{play.hands | player => hand, round_winner => winner_hand}

    %{play | round: round, hands: hands}
  end
end
