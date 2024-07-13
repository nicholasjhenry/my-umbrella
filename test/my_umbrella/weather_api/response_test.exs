defmodule MyUmbrella.WeatherApi.ResponseTest do
  use ExUnit.Case

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

      actual_current_weather = List.first(weather_data)
      utc_2130 = ~U[2000-01-01 21:30:00Z]
      expected_current_weather = %Weather{datetime: utc_2130, code: 802}

      assert expected_current_weather.datetime == actual_current_weather.datetime
      assert expected_current_weather.code == actual_current_weather.code

      actual_forecasted_weather = List.last(weather_data)
      utc_0100 = ~U[2000-01-02 01:00:00Z]
      expected_forecasted_weather = %Weather{datetime: utc_0100, code: 804}

      assert expected_forecasted_weather.datetime == actual_forecasted_weather.datetime
      assert expected_forecasted_weather.code == actual_forecasted_weather.code
    end
  end
end
