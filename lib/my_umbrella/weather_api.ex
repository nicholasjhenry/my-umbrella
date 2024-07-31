defmodule MyUmbrella.WeatherApi do
  @moduledoc """
  An external dependency to get weather forecasts.

  - Current and forecasts weather data: https://openweathermap.org/api/one-call-3#current
  - Weather Conditions: https://openweathermap.org/weather-conditions
  """

  alias MyUmbrella.WeatherApi.Response

  @type coordinates :: {float(), float()}

  @orlando {28.5383, -81.3792}
  @london {51.5098, -0.118}

  @spec get_forecast(coordinates, duration :: :today) :: {:ok, Response.t()}
  def get_forecast(@london, :today) do
    control_path = Application.app_dir(:my_umbrella, "priv/controls")
    control_pathname = Path.join([control_path, "weather_api/response/success_london.json"])
    response = control_pathname |> File.read!() |> :json.decode()

    {:ok, response}
  end

  def get_forecast(@orlando, :today) do
    control_path = Application.app_dir(:my_umbrella, "priv/controls")
    control_pathname = Path.join([control_path, "weather_api/response/success_orlando.json"])
    response = control_pathname |> File.read!() |> :json.decode()

    {:ok, response}
  end
end
