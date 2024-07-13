defmodule MyUmbrella.WeatherApi.ResponseTest do
  use ExUnit.Case

  alias MyUmbrella.Coordinates
  alias MyUmbrella.Weather
  alias MyUmbrella.WeatherApi.Response

  project_path = Mix.Project.project_file() |> Path.dirname()
  fixture_path = Path.join([project_path, "test/support/fixtures"])
  @fixture_pathname Path.join([fixture_path, "response/success.json"])

  describe "converting a response" do
    test "given an API response; returns weather data for current and forecasted conditions" do
      response = @fixture_pathname |> File.read!() |> :json.decode()

      result = Response.to_weather(response)

      assert {:ok, weather_data} = result
      assert Enum.count(weather_data) == 5

      london = Coordinates.new(51.5098, -0.118)

      actual_current_weather = List.first(weather_data)

      utc_2130 = ~U[2000-01-01 21:30:00Z]
      expected_current_weather = %Weather{coordinates: london, datetime: utc_2130, code: 802}

      assert Weather.eq?(expected_current_weather, actual_current_weather)

      actual_forecasted_weather = List.last(weather_data)

      utc_0100 = ~U[2000-01-02 01:00:00Z]
      expected_forecasted_weather = %Weather{coordinates: london, datetime: utc_0100, code: 804}

      assert Weather.eq?(expected_forecasted_weather, actual_forecasted_weather)
    end
  end
end
