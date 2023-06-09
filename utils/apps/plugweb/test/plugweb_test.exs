defmodule PlugwebTest do
  use ExUnit.Case
  doctest Plugweb

  test "greets the world" do
    assert Plugweb.hello() == :world
  end
end
