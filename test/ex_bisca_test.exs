defmodule ExBiscaTest do
  use ExUnit.Case
  doctest ExBisca

  test "greets the world" do
    assert ExBisca.hello() == :world
  end
end
