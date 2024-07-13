defmodule MyUmbrella.WeatherApi.ResponseTest do
  use ExUnit.Case

  alias MyUmbrella.Weather
  alias MyUmbrella.WeatherApi.Response

  project_path = Mix.Project.project_file() |> Path.dirname()
  fixture_path = Path.join([project_path, "test/support/fixtures"])
  @fixture_pathname Path.join([fixture_path, "response/success.json"])

  describe "converting a response" do
    test "given an API response; returns weather data" do
      response = @fixture_pathname |> File.read!() |> :json.decode()

      result = Response.to_weather(response)

      assert {:ok, weather_data} = result
      assert Enum.count(weather_data) == 3

      actual_weather = List.last(weather_data)
      edt_2300 = ~U[2000-01-02 03:00:00Z]
      expected_weather = %Weather{datetime: edt_2300, code: 804}

      assert expected_weather.datetime == actual_weather.datetime
      assert expected_weather.code == actual_weather.code
    end
  end
end
