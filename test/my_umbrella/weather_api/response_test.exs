defmodule MyUmbrella.WeatherApi.ResponseTest do
  use ExUnit.Case

  alias MyUmbrella.Coordinates
  alias MyUmbrella.Weather
  alias MyUmbrella.WeatherApi.Response

  project_path = Mix.Project.project_file() |> Path.dirname()
  fixture_path = Path.join([project_path, "test/support/fixtures"])
  @fixture_pathname Path.join([fixture_path, "response/success.json"])

  describe "converting a response" do
    test "given an API response; returns a weather report for current and forecasted conditions" do
      response = @fixture_pathname |> File.read!() |> :json.decode()

      result = Response.to_weather_report(response)

      assert {:ok, weather_report} = result

      london = Coordinates.new(51.5098, -0.118)
      assert weather_report.coordinates == london
      assert weather_report.time_zone == "Europe/London"

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
