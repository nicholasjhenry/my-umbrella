defmodule MyUmbrella.PrecipitationTest do
  use MyUmbrella.TestCase, async: true

  alias MyUmbrella.Precipitation
  alias MyUmbrella.Weather
  alias MyUmbrella.WeatherReport

  alias MyUmbrella.Controls.Calendar.CurrentDateTime, as: CurrentDateTimeControl
  alias MyUmbrella.Controls.Coordinates, as: CoordinatesControl

  test "comparing two weather forecasts with a percipitation condition" do
    current_date_time = CurrentDateTimeControl.Utc.example(:london)

    snow =
      Weather.new(
        date_time: current_date_time,
        code: 600,
        condition: :snow
      )

    thunderstorm =
      Weather.new(
        date_time: current_date_time,
        code: 200,
        condition: :thunderstorm
      )

    assert Precipitation.compare(snow, snow) == :eq
    assert Precipitation.compare(snow, thunderstorm) == :gt
    assert Precipitation.compare(thunderstorm, snow) == :lt
  end

  describe "determining the most intense precipitation condition" do
    test "given an empty list; then returns nothing" do
      london = CoordinatesControl.example(:london)
      current_date_time = CurrentDateTimeControl.Utc.example(:london)

      weather_report =
        WeatherReport.new(coordinates: london, time_zone: current_date_time.time_zone)

      result = Precipitation.determine_most_intense_precipitation_condition(weather_report)

      assert result == :no_precipitation
    end

    test "given a single weather report with precipitation; then returns that weather report" do
      london = CoordinatesControl.example(:london)
      current_date_time = CurrentDateTimeControl.Utc.example(:london)

      weather_report =
        WeatherReport.new(coordinates: london, time_zone: current_date_time.time_zone)
        |> WeatherReport.add_weather(
          date_time: current_date_time,
          code: 500,
          condition: :rain
        )

      result = Precipitation.determine_most_intense_precipitation_condition(weather_report)

      expected_weather =
        Weather.new(
          date_time: current_date_time,
          code: 500,
          condition: :rain
        )

      assert {:precipitation, actual_weather} = result
      assert Weather.eq?(actual_weather, expected_weather)
    end

    test "given a single weather report with no precipitation; then returns nothing" do
      london = CoordinatesControl.example(:london)
      current_date_time = CurrentDateTimeControl.Utc.example(:london)

      weather_report =
        WeatherReport.new(coordinates: london, time_zone: current_date_time.time_zone)
        |> WeatherReport.add_weather(
          date_time: current_date_time,
          code: 800,
          condition: :clear
        )

      result = Precipitation.determine_most_intense_precipitation_condition(weather_report)

      assert :no_precipitation == result
    end

    test "given multiple weather reports with precipitation; then returns the most intense weather report" do
      london = CoordinatesControl.example(:london)
      current_date_time = CurrentDateTimeControl.Utc.example(:london)

      weather_report =
        WeatherReport.new(coordinates: london, time_zone: "Etc/UTC")
        |> WeatherReport.add_weather(
          date_time: current_date_time,
          condition: :drizzle,
          code: 300
        )
        |> WeatherReport.add_weather(
          date_time: DateTime.shift(current_date_time, hour: 1),
          condition: :thunderstorm,
          code: 200
        )
        |> WeatherReport.add_weather(
          date_time: DateTime.shift(current_date_time, hour: 2),
          condition: :rain,
          code: 500
        )

      result =
        Precipitation.determine_most_intense_precipitation_condition(weather_report)

      expected_weather =
        Weather.new(
          date_time: DateTime.shift(current_date_time, hour: 1),
          condition: :thunderstorm,
          code: 200
        )

      assert {:precipitation, actual_weather} = result
      assert Weather.eq?(expected_weather, actual_weather)
    end
  end
end
