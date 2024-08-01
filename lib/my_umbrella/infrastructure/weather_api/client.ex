defmodule MyUmbrella.Infrastructure.WeatherApi.Client do
  @moduledoc """
  An high-level infrastructure wrapper for Open Weather Map to get weather forecasts.

  - Current and forecasts weather data: https://openweathermap.org/api/one-call-3#current
  - Weather Conditions: https://openweathermap.org/weather-conditions
  """

  alias MyUmbrella.Infrastructure.Http
  alias MyUmbrella.Infrastructure.WeatherApi

  alias MyUmbrella.Controls.Infrastructure.WeatherApi, as: WeatherApiControl

  @type t() :: %WeatherApi.Client{
          http_client: Http.Client.t()
        }

  defstruct [:http_client]

  @type coordinates :: {float(), float()}

  @spec create() :: t()
  def create do
    %WeatherApi.Client{
      http_client: Http.Client.create()
    }
  end

  @spec create_null() :: t()
  def create_null do
    %WeatherApi.Client{
      http_client: Http.Client.create_null()
    }
  end

  @spec get_forecast(t(), coordinates, duration :: :today) :: {:ok, WeatherApi.Response.t()}
  def get_forecast(_weather_api_client, coordinates, :today) do
    WeatherApiControl.Client.get_forecast(coordinates, :today)
  end
end
