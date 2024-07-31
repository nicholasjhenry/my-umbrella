defmodule MyUmbrella.WeatherApi do
  @moduledoc """
  An external dependency to get weather forecasts.

  - Current and forecasts weather data: https://openweathermap.org/api/one-call-3#current
  - Weather Conditions: https://openweathermap.org/weather-conditions
  """

  alias MyUmbrella.WeatherApi.Response

  alias MyUmbrella.Controls.WeatherApi, as: WeatherApiControl

  @type coordinates :: {float(), float()}

  @spec get_forecast(coordinates, duration :: :today) :: {:ok, Response.t()}
  def get_forecast(coordinates, :today) do
    WeatherApiControl.get_forecast(coordinates, :today)
  end
end
