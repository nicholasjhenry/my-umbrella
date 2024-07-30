defmodule MyUmbrella.WeatherApi.ResponseTest do
  use MyUmbrella.TestCase, async: true

  alias MyUmbrella.Weather
  alias MyUmbrella.WeatherApi.Response

  import MyUmbrella.Fixtures

  describe "converting a response" do
    test "given an API response; returns a weather report for current and forecasted conditions",
         %{fixture_path: fixture_path} do
      fixture_pathname = Path.join([fixture_path, "weather_api/response/success_london.json"])
      response = fixture_pathname |> File.read!() |> :json.decode()

      result = Response.to_weather_report(response)

      assert {:ok, weather_report} = result

      london = coordinates_fixture(:london)
      assert weather_report.coordinates == london
      assert weather_report.time_zone == "Etc/UTC"

      assert Enum.count(weather_report.weather) == 5
      utc_2130 = ~U[2000-01-01 21:30:00Z]

      expected_current_weather =
        Weather.new(
          date_time: utc_2130,
          condition: :clouds,
          code: 802
        )

      actual_current_weather = List.first(weather_report.weather)

      assert Weather.eq?(expected_current_weather, actual_current_weather)

      actual_forecasted_weather = List.last(weather_report.weather)

      utc_0100 = ~U[2000-01-02 01:00:00Z]

      expected_forecasted_weather =
        Weather.new(
          date_time: utc_0100,
          condition: :clouds,
          code: 804
        )

      assert Weather.eq?(expected_forecasted_weather, actual_forecasted_weather)
    end
  end
end
