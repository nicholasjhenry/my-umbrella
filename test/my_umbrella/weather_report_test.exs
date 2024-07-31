defmodule MyUmbrella.WeatherReportTest do
  use MyUmbrella.TestCase, async: true

  alias MyUmbrella.Weather
  alias MyUmbrella.WeatherReport

  alias MyUmbrella.Controls.Calendar.CurrentDateTime, as: CurrentDateTimeControl
  alias MyUmbrella.Controls.Coordinates, as: CoordinatesControl

  describe "filter weather report for the same day" do
    test "given an empty list; then returns an empty list" do
      london = CoordinatesControl.example(:london)
      current_date_time = CurrentDateTimeControl.Utc.example(:london)

      weather_report =
        WeatherReport.new(coordinates: london, time_zone: current_date_time.time_zone)

      filtered_weather_report =
        WeatherReport.filter_by_same_day(weather_report, current_date_time)

      refute Enum.any?(filtered_weather_report.weather)
    end

    test "given a single weather forecast reported before midnight; then includes that weather forecast" do
      london = CoordinatesControl.example(:london)
      current_date_time = CurrentDateTimeControl.Utc.example(:london)
      before_midnight = CurrentDateTimeControl.before_midnight(current_date_time)

      weather_report =
        WeatherReport.new(coordinates: london, time_zone: current_date_time.time_zone)
        |> WeatherReport.add_weather(date_time: before_midnight, code: 500, condition: :rain)

      filtered_weather_report =
        WeatherReport.filter_by_same_day(weather_report, current_date_time)

      filtered_weather = List.first(filtered_weather_report.weather)
      weather = List.first(weather_report.weather)
      assert Weather.eq?(filtered_weather, weather)
    end

    test "given a single weather report after midnight; then excludes that report" do
      london = CoordinatesControl.example(:london)
      current_date_time = CurrentDateTimeControl.Utc.example(:london)
      after_midnight = CurrentDateTimeControl.after_midnight(current_date_time)

      weather_report =
        WeatherReport.new(coordinates: london, time_zone: current_date_time.time_zone)
        |> WeatherReport.add_weather(date_time: after_midnight, code: 500, condition: :rain)

      filtered_weather_report =
        WeatherReport.filter_by_same_day(weather_report, current_date_time)

      refute Enum.any?(filtered_weather_report.weather)
    end

    test "given a weather report from another time zone before midnight; then includes that weather forecast" do
      orlando = CoordinatesControl.example(:orlando)
      current_date_time = CurrentDateTimeControl.LocalTime.example(:orlando)
      before_midnight = CurrentDateTimeControl.before_midnight(current_date_time)

      weather_report =
        WeatherReport.new(coordinates: orlando, time_zone: current_date_time.time_zone)
        |> WeatherReport.add_weather(date_time: before_midnight, code: 500, condition: :rain)

      filtered_weather_report =
        WeatherReport.filter_by_same_day(weather_report, current_date_time)

      filtered_weather = List.first(filtered_weather_report.weather)
      weather = List.first(weather_report.weather)
      assert Weather.eq?(filtered_weather, weather)
    end

    test "given a weather report from another timezone after midnight; then excludes that weather forecast" do
      orlando = CoordinatesControl.example(:orlando)
      current_date_time = CurrentDateTimeControl.LocalTime.example(:orlando)
      after_midnight = CurrentDateTimeControl.after_midnight(current_date_time)

      weather_report =
        WeatherReport.new(coordinates: orlando, time_zone: current_date_time.time_zone)
        |> WeatherReport.add_weather(date_time: after_midnight, code: 500, condition: :rain)

      filtered_weather_report =
        WeatherReport.filter_by_same_day(weather_report, current_date_time)

      refute Enum.any?(filtered_weather_report.weather)
    end

    test "given a mismatch of timezones; then raises an error" do
      london = CoordinatesControl.example(:london)
      current_date_time = CurrentDateTimeControl.Utc.example(:london)
      before_midnight = CurrentDateTimeControl.LocalTime.example(:orlando)

      weather_report =
        WeatherReport.new(coordinates: london, time_zone: "America/New_York")
        |> WeatherReport.add_weather(date_time: before_midnight, code: 500, condition: :rain)

      assert_raise RuntimeError, ~r/mismatch with time zones/, fn ->
        WeatherReport.filter_by_same_day(weather_report, current_date_time)
      end
    end
  end
end
