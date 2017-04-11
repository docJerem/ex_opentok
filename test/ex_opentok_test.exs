defmodule ExOpentokTest do
  use ExUnit.Case
  doctest ExOpentok

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "hello world" do
    assert ExOpentok.hello() == :world
  end
end
