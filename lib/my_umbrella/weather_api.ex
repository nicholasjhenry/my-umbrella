defmodule MyUmbrella.WeatherApi do
  @moduledoc """
  An external dependency to get weather forecasts.

  - Current and forecasts weather data: https://openweathermap.org/api/one-call-3#current
  - Weather Conditions: https://openweathermap.org/weather-conditions
  """

  @behaviour MyUmbrella.WeatherApi.Behaviour

  @impl true
  def get_forecast(coordinates, duration), do: impl().get_forecast(coordinates, duration)

  defp impl do
    Application.get_env(:my_umbrella, :weather_api_module, MyUmbrella.WeatherApi.Http)
  end
end
