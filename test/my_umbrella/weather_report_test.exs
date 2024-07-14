defmodule MyUmbrella.WeatherApi.WeatherReportTest do
  use ExUnit.Case

  alias MyUmbrella.WeatherReport
  alias MyUmbrella.Coordinates

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

    test "given a multiple weather reports with precipitation; then returns the most intense weather report" do
      # TODO: pending
    end
  end
end
