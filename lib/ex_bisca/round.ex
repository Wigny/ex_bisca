defmodule ExBisca.Round do
  alias ExBisca.{Card, Deck, Hand, Player}
  alias ExBisca.Round.Trick

  @type player :: Player.t()
  @type player_id :: Player.id()
  @type card :: Card.t()
  @type hand :: Hand.t()
  @type deck :: Deck.t()
  @type trick :: Trick.t()
  @type t :: %__MODULE__{
          deck: deck | nil,
          trump: card | nil,
          player_ids: list(player_id),
          hands: %{player_id => hand} | nil,
          trick: trick | nil
        }

  defstruct [:deck, :trump, :trick, :hands, player_ids: []]

  @max_players 2

  @spec join(round :: t, player_id) :: t
  def join(round \\ %__MODULE__{}, player_id) when length(round.player_ids) < @max_players do
    %{round | player_ids: round.player_ids ++ [player_id]}
  end

  @spec start(round :: t) :: t
  def start(%__MODULE__{} = round) when length(round.player_ids) == @max_players do
    deck = Deck.new()
    hands = Map.from_keys(round.player_ids, Hand.new())

    %{round | deck: deck, hands: hands}
    |> deal_cards(3)
    |> turn_up_trump()
    |> start_first_trick()
  end

  defp deal_cards(round, count) do
    Enum.reduce(round.hands, round, fn {player_id, hand}, round ->
      {cards, deck} = Deck.draw(round.deck, count)

      %{round | deck: deck, hands: %{round.hands | player_id => Hand.deal(hand, cards)}}
    end)
  end

  defp turn_up_trump(round) do
    trump = List.last(round.deck)

    %{round | trump: trump}
  end

  defp start_first_trick(round) do
    %{round | trick: Trick.new(round.player_ids)}
  end

  @spec move(round :: t, player_id, card) :: t
  def move(round, player_id, card) do
    round
    |> move_player_card(player_id, card)
    |> prepare_next_move()
  end

  @spec complete?(round :: t) :: boolean
  def complete?(round) do
    Enum.empty?(round.deck) and
      Enum.all?(round.hands, fn {_player_id, hand} -> Enum.empty?(hand.cards) end)
  end

  @winner_score 60

  @spec winner_id(round :: t) :: player_id | nil
  def winner_id(round) do
    Enum.find_value(round.hands, fn {player_id, hand} ->
      if hand.score > @winner_score, do: player_id
    end)
  end

  defp move_player_card(round, player_id, card) do
    hand = Hand.drop(round.hands[player_id], card)
    trick = Trick.move(round.trick, player_id, card)

    %{round | hands: %{round.hands | player_id => hand}, trick: trick}
  end

  defp prepare_next_move(round) do
    if Trick.complete?(round.trick) do
      prepare_next_trick(round)
    else
      round
    end
  end

  defp prepare_next_trick(round) do
    trick_winner_id = Trick.winner_id(round.trick, round.trump)
    trick_score = Trick.score(round.trick)

    winner_hand = Hand.increase_score(round.hands[trick_winner_id], trick_score)

    trick = Trick.restart(round.trick, trick_winner_id)
    hands = %{round.hands | trick_winner_id => winner_hand}

    deal_cards(%{round | trick: trick, hands: hands}, 1)
  end
end
