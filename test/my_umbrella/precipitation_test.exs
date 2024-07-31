defmodule MyUmbrella.PrecipitationTest do
  use MyUmbrella.TestCase, async: true

  alias MyUmbrella.Precipitation
  alias MyUmbrella.Weather
  alias MyUmbrella.WeatherReport

  alias MyUmbrella.Controls.Calendar.CurrentDateTime, as: CurrentDateTimeControl
  alias MyUmbrella.Controls.Weather, as: WeatherControl
  alias MyUmbrella.Controls.WeatherReport, as: WeatherReportControl

  test "comparing two weather forecasts with a percipitation condition" do
    snow = WeatherControl.Snow.example()
    thunderstorm = WeatherControl.Thunderstorm.example()

    assert Precipitation.compare(snow, snow) == :eq
    assert Precipitation.compare(snow, thunderstorm) == :gt
    assert Precipitation.compare(thunderstorm, snow) == :lt
  end

  describe "determining the most intense precipitation condition" do
    test "given an empty list; then returns nothing" do
      weather_report = WeatherReportControl.example()

      result = Precipitation.determine_most_intense_precipitation_condition(weather_report)

      assert result == :no_precipitation
    end

    test "given a single weather report with precipitation; then returns that weather report" do
      weather_report =
        WeatherReportControl.example()
        |> WeatherReport.add_weather(WeatherControl.Rain.attributes())

      result = Precipitation.determine_most_intense_precipitation_condition(weather_report)

      assert {:precipitation, actual_weather} = result
      assert Weather.eq?(actual_weather, WeatherControl.Rain.example())
    end

    test "given a single weather report with no precipitation; then returns nothing" do
      weather_report =
        WeatherReportControl.example()
        |> WeatherReport.add_weather(WeatherControl.Clear.attributes())

      result = Precipitation.determine_most_intense_precipitation_condition(weather_report)

      assert :no_precipitation == result
    end

    test "given multiple weather reports with precipitation; then returns the most intense weather report" do
      current_date_time = CurrentDateTimeControl.Utc.example(:london)
      weather_report = WeatherReportControl.example()

      weather_report =
        weather_report
        |> WeatherReport.add_weather(WeatherControl.Drizzle.attributes(current_date_time))
        |> WeatherReport.add_weather(
          WeatherControl.Thunderstorm.attributes(DateTime.shift(current_date_time, hour: 1))
        )
        |> WeatherReport.add_weather(
          WeatherControl.Rain.attributes(DateTime.shift(current_date_time, hour: 2))
        )

      result = Precipitation.determine_most_intense_precipitation_condition(weather_report)

      expected_weather =
        WeatherControl.Thunderstorm.attributes(DateTime.shift(current_date_time, hour: 1))

      assert {:precipitation, actual_weather} = result
      assert Weather.eq?(expected_weather, actual_weather)
    end
  end
end
