defmodule MyUmbrellaTest do
  use ExUnit.Case
  doctest MyUmbrella

  test "greets the world" do
    assert MyUmbrella.hello() == :world
  end
end
