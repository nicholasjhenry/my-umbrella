defmodule MyUmbrellaTest do
  use ExUnit.Case

  alias MyUmbrella.Coordinates
  alias MyUmbrella.Weather

  describe "determine if an umbrella is needed today" do
    test "given it IS raining before end-of-day; then an umbrella IS needed" do
      london = Coordinates.new(51.5098, -0.118)

      weather_result = MyUmbrella.for_today(london)

      expected_weather =
        Weather.new(date_time: ~U[2000-01-01 22:00:00Z], condition: :rain, code: 501)

      assert {:ok, {:precipitation, actual_weather}} = weather_result
      assert Weather.eq?(actual_weather, expected_weather)
    end

    test "given it IS NOT raining before end-of-day; then an umbrella IS NOT needed" do
      orlando = Coordinates.new(28.5383, -81.3792)

      weather_result = MyUmbrella.for_today(orlando)

      assert {:ok, :no_precipitation} == weather_result
    end
  end
end
