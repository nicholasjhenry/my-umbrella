defmodule MyUmbrella.PrecipitationTest do
  use ExUnit.Case

  alias MyUmbrella.Coordinates
  alias MyUmbrella.Precipitation
  alias MyUmbrella.Weather
  alias MyUmbrella.WeatherReport

  test "comparing two weather forecasts with a percipitation condition" do
    utc_2130 = ~U[2000-01-01 21:30:00Z]

    snow = %Weather{
      date_time: utc_2130,
      code: 600,
      condition: :snow
    }

    thunderstorm = %Weather{
      date_time: utc_2130,
      code: 200,
      condition: :thunderstorm
    }

    assert Precipitation.compare(snow, snow) == :eq
    assert Precipitation.compare(snow, thunderstorm) == :gt
    assert Precipitation.compare(thunderstorm, snow) == :lt
  end

  describe "determining the most intense precipitation condition" do
    @tag :wip

    test "given an empty list; then returns nothing" do
      london = Coordinates.new(51.5098, -0.118)
      weather_report = WeatherReport.new(coordinates: london, timezone: "Europe/London")

      precipitation = Precipitation.determine_most_intense_precipitation_condition(weather_report)
      refute precipitation
    end

    @tag :wip
    test "given a single weather report with precipitation; then returns that weather report" do
      london = Coordinates.new(51.5098, -0.118)
      utc_2130 = ~U[2000-01-01 21:30:00Z]

      weather_report =
        WeatherReport.new(coordinates: london, timezone: "Europe/London")
        |> WeatherReport.add_weather(
          date_time: utc_2130,
          code: 500,
          condition: :rain
        )

      actual_precipitation =
        Precipitation.determine_most_intense_precipitation_condition(weather_report)

      expected_precipitation = %Weather{
        date_time: utc_2130,
        code: 500,
        condition: :rain
      }

      assert Weather.eq?(actual_precipitation, expected_precipitation)
    end

    @tag :wip
    test "given a single weather report with no precipitation; then returns nothing" do
      london = Coordinates.new(51.5098, -0.118)
      utc_2130 = ~U[2000-01-01 21:30:00Z]

      weather_report =
        WeatherReport.new(coordinates: london, timezone: "Europe/London")
        |> WeatherReport.add_weather(
          date_time: utc_2130,
          code: 800,
          condition: :clear
        )

      precipitation =
        Precipitation.determine_most_intense_precipitation_condition(weather_report)

      refute precipitation
    end

    @tag :wip
    test "given multiple weather reports with precipitation; then returns the most intense weather report" do
      london = Coordinates.new(51.5098, -0.118)
      utc_2130 = ~U[2000-01-01 21:30:00Z]

      weather_report =
        WeatherReport.new(coordinates: london, timezone: "Europe/London")
        |> WeatherReport.add_weather(
          date_time: utc_2130,
          condition: :drizzle,
          code: 300
        )
        |> WeatherReport.add_weather(
          date_time: utc_2130,
          condition: :thunderstorm,
          code: 200
        )
        |> WeatherReport.add_weather(
          date_time: utc_2130,
          condition: :rain,
          code: 500
        )

      actual_precipitation =
        Precipitation.determine_most_intense_precipitation_condition(weather_report)

      expected_precipitation =
        Weather.new(
          date_time: utc_2130,
          condition: :thunderstorm,
          code: 200
        )

      assert Weather.eq?(expected_precipitation, actual_precipitation)
    end
  end
end
