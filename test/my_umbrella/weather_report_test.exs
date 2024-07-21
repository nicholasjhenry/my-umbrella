defmodule MyUmbrella.WeatherApi.WeatherReportTest do
  use ExUnit.Case

  alias MyUmbrella.Coordinates
  alias MyUmbrella.WeatherReport

  test "comparing two weather reports with a percipitation condition" do
    london = Coordinates.new(51.5098, -0.118)
    utc_2130 = ~U[2000-01-01 21:30:00Z]

    snow_report = %WeatherReport{
      coordinates: london,
      datetime: utc_2130,
      code: 600,
      condition: :snow
    }

    thunderstorm_report = %WeatherReport{
      coordinates: london,
      datetime: utc_2130,
      code: 200,
      condition: :thunderstorm
    }

    assert WeatherReport.compare(snow_report, snow_report) == :eq
    assert WeatherReport.compare(snow_report, thunderstorm_report) == :gt
    assert WeatherReport.compare(thunderstorm_report, snow_report) == :lt
  end

  describe "determining the most intense precipitation condition" do
    test "given an empty list; then returns nothing" do
      weather_reports = []
      weather = WeatherReport.determine_most_intense_precipitation_condition(weather_reports)
      refute weather
    end

    test "given a single weather report with precipitation; then returns that weather report" do
      london = Coordinates.new(51.5098, -0.118)
      utc_2130 = ~U[2000-01-01 21:30:00Z]

      single_weather_report = %WeatherReport{
        coordinates: london,
        datetime: utc_2130,
        code: 500,
        condition: :rain
      }

      weather_reports = [single_weather_report]

      actual_weather_report =
        WeatherReport.determine_most_intense_precipitation_condition(weather_reports)

      assert WeatherReport.eq?(actual_weather_report, single_weather_report)
    end

    test "given a single weather report with no precipitation; then returns nothing" do
      london = Coordinates.new(51.5098, -0.118)
      utc_2130 = ~U[2000-01-01 21:30:00Z]

      single_weather_report = %WeatherReport{
        coordinates: london,
        datetime: utc_2130,
        condition: :clear,
        code: 800
      }

      weather_reports = [single_weather_report]

      weather_report =
        WeatherReport.determine_most_intense_precipitation_condition(weather_reports)

      refute weather_report
    end

    test "given multiple weather reports with precipitation; then returns the most intense weather report" do
      london = Coordinates.new(51.5098, -0.118)
      utc_2130 = ~U[2000-01-01 21:30:00Z]

      drizzle_report = %WeatherReport{
        coordinates: london,
        datetime: utc_2130,
        condition: :drizzle,
        code: 300
      }

      thunderstorm_report = %WeatherReport{
        coordinates: london,
        datetime: utc_2130,
        condition: :thunderstorm,
        code: 200
      }

      rain_report = %WeatherReport{
        coordinates: london,
        datetime: utc_2130,
        condition: :rain,
        code: 500
      }

      weather_reports = [drizzle_report, thunderstorm_report, rain_report]

      weather_report =
        WeatherReport.determine_most_intense_precipitation_condition(weather_reports)

      assert WeatherReport.eq?(weather_report, thunderstorm_report)
    end
  end
end
