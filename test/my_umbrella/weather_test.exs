defmodule MyUmbrella.WeatherApi.WeatherTest do
  use ExUnit.Case

  alias MyUmbrella.Weather
  alias MyUmbrella.Coordinates

  describe "determining the most intense precipitation condition" do
    test "given empty list; then returns nothing" do
      weather_data = []
      weather = Weather.determine_most_intense_precipitation_condition(weather_data)
      refute weather
    end

    test "given a single weather report with precipitation; then returns that weather report" do
      london = Coordinates.new(51.5098, -0.118)
      utc_2130 = ~U[2000-01-01 21:30:00Z]

      single_weather = %Weather{
        coordinates: london,
        datetime: utc_2130,
        code: 500,
        condition: :rain
      }

      weather_data = [single_weather]
      actual_weather = Weather.determine_most_intense_precipitation_condition(weather_data)
      assert Weather.eq?(actual_weather, single_weather)
    end

    test "given a single weather report with no precipitation; then returns nothing" do
      london = Coordinates.new(51.5098, -0.118)
      utc_2130 = ~U[2000-01-01 21:30:00Z]

      single_weather = %Weather{
        coordinates: london,
        datetime: utc_2130,
        condition: :clear,
        code: 800
      }

      weather_data = [single_weather]
      weather = Weather.determine_most_intense_precipitation_condition(weather_data)

      refute weather
    end

    test "given a multiple weather reports with precipitation; then returns the most intense weather report" do
      # TODO: pending
    end
  end
end
