defmodule EctoClassTest do
  use ExUnit.Case
  doctest EctoClass

  test "greets the world" do
    assert EctoClass.hello() == :world
  end
end
