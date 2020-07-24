defmodule RemotePicamTest do
  use ExUnit.Case
  doctest RemotePicam

  test "greets the world" do
    assert RemotePicam.hello() == :world
  end
end
