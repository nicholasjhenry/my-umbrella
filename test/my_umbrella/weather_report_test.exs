defmodule MyUmbrella.WeatherReportTest do
  use ExUnit.Case

  alias MyUmbrella.Coordinates
  alias MyUmbrella.Weather
  alias MyUmbrella.WeatherReport

  describe "filter weather report for the same day" do
    test "given an empty list; then returns an empty list" do
      london = Coordinates.new(51.5098, -0.118)
      weather_report = %WeatherReport{coordinates: london}

      current_date_time = ~U[2000-01-01 21:00:00Z]

      filtered_weather_report =
        WeatherReport.filter_by_same_day(weather_report, current_date_time)

      refute Enum.any?(filtered_weather_report.weather)
    end

    test "given a single weather forecast reported before midnight; then includes that weather forecast" do
      london = Coordinates.new(51.5098, -0.118)
      utc_2130 = ~U[2000-01-01 21:30:00Z]

      weather_report =
        WeatherReport.new(coordinates: london)
        |> WeatherReport.add_weather(date_time: utc_2130, code: 500, condition: :rain)

      current_date_time = ~U[2000-01-01 21:00:00Z]

      filtered_weather_report =
        WeatherReport.filter_by_same_day(weather_report, current_date_time)

      filtered_weather = List.first(filtered_weather_report.weather)
      weather = List.first(weather_report.weather)
      assert Weather.eq?(filtered_weather, weather)
    end

    test "given a single weather report after midnight; then excludes that report" do
      london = Coordinates.new(51.5098, -0.118)
      utc_0030 = ~U[2000-01-02 00:30:00Z]

      weather_report =
        WeatherReport.new(coordinates: london)
        |> WeatherReport.add_weather(date_time: utc_0030, code: 500, condition: :rain)

      current_date_time = ~U[2000-01-01 21:00:00Z]

      filtered_weather_report =
        WeatherReport.filter_by_same_day(weather_report, current_date_time)

      refute Enum.any?(filtered_weather_report.weather)
    end
  end
end
