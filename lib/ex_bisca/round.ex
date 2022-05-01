defmodule ExBisca.Round do
  use TypedStruct

  alias ExBisca.Deck
  alias ExBisca.Deck.Card

  @type player_id :: any
  @type hand :: list(Card.t())
  @type score :: integer

  typedstruct opaque: true do
    field :deck, list(Card.t())
    field :trump, Card.t()
    field :hands, list({player_id, hand, score}), default: []
    field :instructions, any, default: []
  end

  def start(players) do
    round =
      %__MODULE__{deck: Deck.new()}
      |> deals_cards(players)
      |> take_trump()
      |> first_move(players)

    {Enum.reverse(round.instructions), %{round | instructions: []}}
  end

  defp deals_cards(round, players) do
    Enum.reduce(players, round, fn player, acc ->
      {cards, deck} = Deck.take(acc.deck, 3)

      hand = {player, cards, 0}
      instruction = {:notify_player, player, {:deal_cards, cards}}

      %{
        acc
        | deck: deck,
          hands: [hand | acc.hands],
          instructions: [instruction | acc.instructions]
      }
    end)
  end

  defp take_trump(round) do
    {[trump], deck} = Deck.take(round.deck, 1)
    instruction = {:notify_player, :all, {:trump_card, trump}}

    %{round | deck: deck, trump: trump, instructions: [instruction | round.instructions]}
  end

  defp first_move(round, [player | _players]) do
    instruction = {:notify_player, player, :move}

    %{round | instructions: [instruction | round.instructions]}
  end
end
