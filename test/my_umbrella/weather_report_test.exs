defmodule MyUmbrella.WeatherReportTest do
  use ExUnit.Case

  alias MyUmbrella.Coordinates
  alias MyUmbrella.Weather
  alias MyUmbrella.WeatherReport

  describe "filter weather report for the same day" do
    test "given an empty list; then returns an empty list" do
      london = Coordinates.new(51.5098, -0.118)
      weather_report = WeatherReport.new(coordinates: london, time_zone: "Etc/UTC")

      current_date_time = ~U[2000-01-01 21:00:00Z]

      filtered_weather_report =
        WeatherReport.filter_by_same_day(weather_report, current_date_time)

      refute Enum.any?(filtered_weather_report.weather)
    end

    test "given a single weather forecast reported before midnight; then includes that weather forecast" do
      london = Coordinates.new(51.5098, -0.118)
      utc_2130 = ~U[2000-01-01 21:30:00Z]

      weather_report =
        WeatherReport.new(coordinates: london, time_zone: "Etc/UTC")
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
        WeatherReport.new(coordinates: london, time_zone: "Etc/UTC")
        |> WeatherReport.add_weather(date_time: utc_0030, code: 500, condition: :rain)

      current_date_time = ~U[2000-01-01 21:00:00Z]

      filtered_weather_report =
        WeatherReport.filter_by_same_day(weather_report, current_date_time)

      refute Enum.any?(filtered_weather_report.weather)
    end

    test "given a weather report from another time zone before midnight; then includes that weather forecast" do
      london = Coordinates.new(51.5098, -0.118)
      est_2130 = DateTime.new!(~D[2000-01-01], ~T[21:30:00.00], "America/New_York")

      weather_report =
        WeatherReport.new(coordinates: london, time_zone: "America/New_York")
        |> WeatherReport.add_weather(date_time: est_2130, code: 500, condition: :rain)

      current_date_time = DateTime.new!(~D[2000-01-01], ~T[21:00:00.00], "America/New_York")

      filtered_weather_report =
        WeatherReport.filter_by_same_day(weather_report, current_date_time)

      filtered_weather = List.first(filtered_weather_report.weather)
      weather = List.first(weather_report.weather)
      assert Weather.eq?(filtered_weather, weather)
    end

    test "given a weather report from another timezone after midnight; then excludes that weather forecast" do
      london = Coordinates.new(51.5098, -0.118)
      est_0030 = DateTime.new!(~D[2000-01-02], ~T[00:30:00.00], "America/New_York")

      weather_report =
        WeatherReport.new(coordinates: london, time_zone: "America/New_York")
        |> WeatherReport.add_weather(date_time: est_0030, code: 500, condition: :rain)

      current_date_time = DateTime.new!(~D[2000-01-01], ~T[21:00:00.00], "America/New_York")

      filtered_weather_report =
        WeatherReport.filter_by_same_day(weather_report, current_date_time)

      refute Enum.any?(filtered_weather_report.weather)
    end

    test "given a mismatch of timezones; then raises an error" do
      london = Coordinates.new(51.5098, -0.118)
      est_0030 = DateTime.new!(~D[2000-01-02], ~T[00:30:00.00], "America/New_York")

      weather_report =
        WeatherReport.new(coordinates: london, time_zone: "America/New_York")
        |> WeatherReport.add_weather(date_time: est_0030, code: 500, condition: :rain)

      current_date_time = DateTime.new!(~D[2000-01-01], ~T[21:00:00.00], "Etc/UTC")

      assert_raise RuntimeError, ~r/mismatch with time zones/, fn ->
        WeatherReport.filter_by_same_day(weather_report, current_date_time)
      end
    end
  end
end
