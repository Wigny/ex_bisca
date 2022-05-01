defmodule ExBisca.RoundTest do
  use ExUnit.Case
  alias ExBisca.Round
  alias ExBisca.Deck.Card

  test "start/2 return first instructions" do
    {instructions, _round} = Round.start([:player_1, :player_2])

    assert [
             {:notify_player, :player_1, {:deal_cards, _player_1_cards}},
             {:notify_player, :player_2, {:deal_cards, _player_2_cards}},
             {:notify_player, :all, {:trump_card, _trump_card}},
             {:notify_player, :player_1, :move}
           ] = instructions
  end
end
