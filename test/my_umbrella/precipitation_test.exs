defmodule MyUmbrella.PrecipitationTest do
  use MyUmbrella.TestCase, async: true

  alias MyUmbrella.Precipitation
  alias MyUmbrella.Weather
  alias MyUmbrella.WeatherReport

  import MyUmbrella.Fixtures

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
      london = coordinates_fixture(:london)
      weather_report = WeatherReport.new(coordinates: london, time_zone: "Etc/UTC")

      result = Precipitation.determine_most_intense_precipitation_condition(weather_report)
      assert result == :no_precipitation
    end

    test "given a single weather report with precipitation; then returns that weather report" do
      london = coordinates_fixture(:london)
      utc_2130 = ~U[2000-01-01 21:30:00Z]

      weather_report =
        WeatherReport.new(coordinates: london, time_zone: "Etc/UTC")
        |> WeatherReport.add_weather(
          date_time: utc_2130,
          code: 500,
          condition: :rain
        )

      result = Precipitation.determine_most_intense_precipitation_condition(weather_report)

      expected_weather = %Weather{
        date_time: utc_2130,
        code: 500,
        condition: :rain
      }

      assert {:precipitation, actual_weather} = result
      assert Weather.eq?(actual_weather, expected_weather)
    end

    test "given a single weather report with no precipitation; then returns nothing" do
      london = coordinates_fixture(:london)
      utc_2130 = ~U[2000-01-01 21:30:00Z]

      weather_report =
        WeatherReport.new(coordinates: london, time_zone: "Etc/UTC")
        |> WeatherReport.add_weather(
          date_time: utc_2130,
          code: 800,
          condition: :clear
        )

      result = Precipitation.determine_most_intense_precipitation_condition(weather_report)

      assert :no_precipitation == result
    end

    test "given multiple weather reports with precipitation; then returns the most intense weather report" do
      london = coordinates_fixture(:london)
      utc_2130 = ~U[2000-01-01 21:30:00Z]

      weather_report =
        WeatherReport.new(coordinates: london, time_zone: "Etc/UTC")
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

      result =
        Precipitation.determine_most_intense_precipitation_condition(weather_report)

      expected_weather =
        Weather.new(
          date_time: utc_2130,
          condition: :thunderstorm,
          code: 200
        )

      assert {:precipitation, actual_weather} = result
      assert Weather.eq?(expected_weather, actual_weather)
    end
  end
end
