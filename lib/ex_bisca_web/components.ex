defmodule ExBiscaWeb.Components do
  use Phoenix.Component

  attr :card, :map, default: nil
  attr :rest, :global, include: [:class]

  def card(%{card: %ExBisca.Play.Card{}} = assigns) do
    ~H"""
    <img src={"images/cards/#{@card.suit}/#{@card.rank}.svg"} {@rest} />
    """
  end

  def card(%{card: nil} = assigns) do
    ~H"""
    <img src="images/cards/blank.svg" {@rest} />
    """
  end
end
