defmodule ExBisca.Play.PlayerTest do
  use ExUnit.Case
  alias ExBisca.Play.Player

  describe "new/2" do
    test "creates a new player" do
      assert %Player{name: "John"} = Player.new("John")
    end
  end
end
