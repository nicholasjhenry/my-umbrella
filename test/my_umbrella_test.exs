defmodule MyUmbrellaTest do
  use ExUnit.Case

  alias MyUmbrella.Coordinates
  alias MyUmbrella.Weather
  alias MyUmbrella.WeatherApi

  describe "determine if an umbrella is needed today" do
    test "given it IS raining before end-of-day; then an umbrella IS needed" do
      orlando = Coordinates.new(28.5383, -81.3792)

      weather_result = MyUmbrella.for_today(orlando, WeatherApi)
      # annoucnement = MyUmbrella.determine_announcement(weather)

      expected_weather =
        Weather.new(date_time: ~U[2000-01-01 22:00:00Z], condition: :rain, code: 501)

      assert {:ok, weather} = weather_result
      assert Weather.eq?(weather, expected_weather)
    end
  end
end
