defmodule MyUmbrella.WeatherApi.ResponseTest do
  use ExUnit.Case

  alias MyUmbrella.Coordinates
  alias MyUmbrella.WeatherApi.Response
  alias MyUmbrella.WeatherReport

  project_path = Mix.Project.project_file() |> Path.dirname()
  fixture_path = Path.join([project_path, "test/support/fixtures"])
  @fixture_pathname Path.join([fixture_path, "response/success.json"])

  describe "converting a response" do
    test "given an API response; returns weather data for current and forecasted conditions" do
      response = @fixture_pathname |> File.read!() |> :json.decode()

      result = Response.to_weather(response)

      assert {:ok, weather_reports} = result
      assert Enum.count(weather_reports) == 5

      london = Coordinates.new(51.5098, -0.118)

      actual_current_weather_report = List.first(weather_reports)

      utc_2130 = ~U[2000-01-01 21:30:00Z]

      expected_current_weather_report = %WeatherReport{
        coordinates: london,
        date_time: utc_2130,
        condition: :clouds,
        code: 802
      }

      assert WeatherReport.eq?(expected_current_weather_report, actual_current_weather_report)

      actual_forecasted_weather_report = List.last(weather_reports)

      utc_0100 = ~U[2000-01-02 01:00:00Z]

      expected_forecasted_weather_report = %WeatherReport{
        coordinates: london,
        date_time: utc_0100,
        condition: :clouds,
        code: 804
      }

      assert WeatherReport.eq?(
               expected_forecasted_weather_report,
               actual_forecasted_weather_report
             )
    end
  end
end
