defmodule MyUmbrella.Infrastucture.WeatherApi.ResponseBodyTest do
  use MyUmbrella.TestCase, async: true

  alias MyUmbrella.Weather

  alias MyUmbrella.Infrastructure.WeatherApi.ResponseBody

  alias MyUmbrella.Controls.Calendar.CurrentDateTime, as: CurrentDateTimeControls
  alias MyUmbrella.Controls.Coordinates, as: CoordinatesControl
  alias MyUmbrella.Controls.Weather, as: WeatherControl

  describe "converting a response" do
    test "given an API response; returns a weather report for current and forecasted conditions",
         %{control_path: control_path} do
      control_pathname =
        Path.join([control_path, "weather_api/response_body/success_london.json"])

      response_body = control_pathname |> File.read!() |> :json.decode()

      result = ResponseBody.to_weather_report(response_body)

      assert {:ok, weather_report} = result

      london = CoordinatesControl.example(:london)
      current_date_time = CurrentDateTimeControls.Utc.example(:london)
      assert weather_report.coordinates == london
      assert weather_report.time_zone == current_date_time.time_zone

      assert Enum.count(weather_report.weather) == 5

      actual_current_weather = List.first(weather_report.weather)
      assert Weather.eq?(WeatherControl.Cloud.example(), actual_current_weather)

      actual_forecasted_weather = List.last(weather_report.weather)

      expected_forecasted_weather = WeatherControl.Cloud.example(~U[2000-01-02 01:00:00Z])

      assert Weather.eq?(expected_forecasted_weather, actual_forecasted_weather)
    end
  end
end
