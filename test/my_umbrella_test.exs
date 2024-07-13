defmodule MyUmbrellaTest do
  use ExUnit.Case

  alias MyUmbrella.Coordinates
  alias MyUmbrella.WeatherApi

  describe "determine if an umbrella is needed today" do
    test "given it is NOT raining before end-of-day; then an umbrella is NOT needed" do
      orlando = Coordinates.new(28.5383, -81.3792)
      assert {:ok, "Nah, all good"} == MyUmbrella.for_today(orlando, WeatherApi)
    end
  end
end
