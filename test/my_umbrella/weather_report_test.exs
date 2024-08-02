defmodule MyUmbrella.WeatherReportTest do
  use MyUmbrella.TestCase, async: true

  alias MyUmbrella.Weather
  alias MyUmbrella.WeatherReport

  alias MyUmbrella.Controls.Weather, as: WeatherControl
  alias MyUmbrella.Controls.WeatherReport, as: WeatherReportControl

  alias MyUmbrella.Infrastructure.Calendar.Controls.CurrentDateTime, as: CurrentDateTimeControl

  describe "filter weather report for the same day" do
    test "given an empty list; then returns an empty list" do
      current_date_time = CurrentDateTimeControl.LocalTime.example(:london)
      weather_report = WeatherReportControl.example()

      filtered_weather_report =
        WeatherReport.filter_by_same_day(weather_report, current_date_time)

      refute Enum.any?(filtered_weather_report.weather)
    end

    test "given a single weather forecast reported before midnight; then includes that weather forecast" do
      current_date_time = CurrentDateTimeControl.LocalTime.example(:london)
      before_midnight = CurrentDateTimeControl.before_midnight(current_date_time)

      weather_report =
        WeatherReportControl.example()
        |> WeatherReport.add_weather(WeatherControl.attributes(before_midnight))

      filtered_weather_report =
        WeatherReport.filter_by_same_day(weather_report, current_date_time)

      filtered_weather = List.first(filtered_weather_report.weather)
      weather = List.first(weather_report.weather)
      assert Weather.eq?(filtered_weather, weather)
    end

    test "given a single weather report after midnight; then excludes that report" do
      current_date_time = CurrentDateTimeControl.LocalTime.example(:london)
      after_midnight = CurrentDateTimeControl.after_midnight(current_date_time)

      weather_report =
        WeatherReportControl.example()
        |> WeatherReport.add_weather(WeatherControl.attributes(after_midnight))

      filtered_weather_report =
        WeatherReport.filter_by_same_day(weather_report, current_date_time)

      refute Enum.any?(filtered_weather_report.weather)
    end

    test "given a weather report from another time zone before midnight; then includes that weather forecast" do
      current_date_time = CurrentDateTimeControl.LocalTime.example(:orlando)
      before_midnight = CurrentDateTimeControl.before_midnight(current_date_time)

      weather_report =
        WeatherReportControl.example(:orlando)
        |> WeatherReport.add_weather(WeatherControl.attributes(before_midnight))

      filtered_weather_report =
        WeatherReport.filter_by_same_day(weather_report, current_date_time)

      filtered_weather = List.first(filtered_weather_report.weather)
      weather = List.first(weather_report.weather)
      assert Weather.eq?(filtered_weather, weather)
    end

    test "given a weather report from another timezone after midnight; then excludes that weather forecast" do
      current_date_time = CurrentDateTimeControl.LocalTime.example(:orlando)
      after_midnight = CurrentDateTimeControl.after_midnight(current_date_time)

      weather_report =
        WeatherReportControl.example(:orlando)
        |> WeatherReport.add_weather(WeatherControl.attributes(after_midnight))

      filtered_weather_report =
        WeatherReport.filter_by_same_day(weather_report, current_date_time)

      refute Enum.any?(filtered_weather_report.weather)
    end

    test "given a mismatch of timezones; then raises an error" do
      current_date_time = CurrentDateTimeControl.LocalTime.example(:london)

      weather_report =
        WeatherReportControl.example(:london, "America/New_York")
        |> WeatherReport.add_weather(WeatherControl.attributes())

      assert_raise RuntimeError, ~r/mismatch with time zones/, fn ->
        WeatherReport.filter_by_same_day(weather_report, current_date_time)
      end
    end
  end
end
