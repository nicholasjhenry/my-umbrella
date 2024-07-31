defmodule MyUmbrella.WeatherApi.ResponseTest do
  use MyUmbrella.TestCase, async: true

  alias MyUmbrella.Coordinates
  alias MyUmbrella.Weather
  alias MyUmbrella.WeatherApi.Response

  alias MyUmbrella.Controls.Calendar.CurrentDateTime, as: CurrentDateTimeControls

  describe "converting a response" do
    test "given an API response; returns a weather report for current and forecasted conditions",
         %{control_path: control_path} do
      control_pathname = Path.join([control_path, "weather_api/response/success.json"])
      response = control_pathname |> File.read!() |> :json.decode()

      result = Response.to_weather_report(response)

      assert {:ok, weather_report} = result

      london = Coordinates.new(51.5098, -0.118)
      current_date_time = CurrentDateTimeControls.Utc.example(:london)
      assert weather_report.coordinates == london
      assert weather_report.time_zone == current_date_time.time_zone

      assert Enum.count(weather_report.weather) == 5

      expected_current_weather =
        Weather.new(
          date_time: current_date_time,
          condition: :clouds,
          code: 802
        )

      actual_current_weather = List.first(weather_report.weather)

      assert Weather.eq?(expected_current_weather, actual_current_weather)

      actual_forecasted_weather = List.last(weather_report.weather)

      expected_forecasted_weather =
        Weather.new(
          date_time: ~U[2000-01-02 01:00:00Z],
          condition: :clouds,
          code: 804
        )

      assert Weather.eq?(expected_forecasted_weather, actual_forecasted_weather)
    end
  end
end
