defmodule ElixirSocketTestingTest do
  use ExUnit.Case
  doctest ElixirSocketTesting

  test "greets the world" do
    assert ElixirSocketTesting.hello() == :world
  end
end
