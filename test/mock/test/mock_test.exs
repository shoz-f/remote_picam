defmodule MockTest do
  use ExUnit.Case
  doctest Mock

  test "greets the world" do
    assert Mock.hello() == :world
  end
end
