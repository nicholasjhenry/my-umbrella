defmodule MyUmbrella do
  @moduledoc """
  A context module.
  """

  alias MyUmbrella.Coordinates
  alias MyUmbrella.WeatherApi

  defmodule Announcement do
    @moduledoc """
    A type for the announcement in regards to the weather conditions.
    """

    @type t :: String.t()
  end

  @spec for_today(Coordinates.t(), module()) :: {:ok, Announcement.t()} | {:error, term}
  def for_today(coordinates, weather_api) do
    with {:ok, response} <- weather_api.get_forecast(coordinates, :today),
         {:ok, _weather} <- WeatherApi.Response.to_weather(response) do
      {:ok, "Nah, all good"}
    end
  end
end
