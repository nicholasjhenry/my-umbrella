defmodule MyUmbrella do
  @moduledoc """
  A context module.
  """

  alias MyUmbrella.WeatherApi

  defmodule Announcement do
    @moduledoc """
    A type for the announcement in regards to the weather conditions.
    """

    @type t :: String.t()
  end

  @type location :: {float(), float()}

  @spec for_today(location, module()) :: {:ok, Announcement.t()} | {:error, term}
  def for_today(location, weather_api) do
    with {:ok, response} <- weather_api.get_forecast(location, :today),
         {:ok, _weather} <- WeatherApi.Response.to_weather(response) do
      {:ok, "Nah, all good"}
    end
  end
end
