defmodule MyUmbrella.WeatherApi do
  @moduledoc """
  An external dependency to get weather forecasts.

  - Current and forecasts weather data: https://openweathermap.org/api/one-call-3#current
  - Weather Conditions: https://openweathermap.org/weather-conditions
  """

  alias MyUmbrella.WeatherApi.Response

  @type coordinates :: {float(), float()}

  @orlando {28.5383, -81.3792}

  @spec get_forecast(coordinates, duration :: :today) :: {:ok, Response.t()}
  def get_forecast(@orlando, :today) do
    project_path = Mix.Project.project_file() |> Path.dirname()
    fixture_path = Path.join([project_path, "test/fixtures"])
    fixture_pathname = Path.join([fixture_path, "response/success.json"])
    response = fixture_pathname |> File.read!() |> :json.decode()

    {:ok, response}
  end
end
