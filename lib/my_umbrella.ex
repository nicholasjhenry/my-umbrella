defmodule MyUmbrella do
  @moduledoc """
  A context module.
  """

  alias MyUmbrella.WeatherReport
  alias MyUmbrella.Coordinates
  alias MyUmbrella.Precipitation
  alias MyUmbrella.Weather
  alias MyUmbrella.WeatherApi

  defmodule Announcement do
    @moduledoc """
    A type for the announcement in regards to the weather conditions.
    """

    @type t :: String.t()
  end

  @spec for_today(Coordinates.t(), module()) :: {:ok, Weather.t()} | {:error, term}
  def for_today(coordinates, weather_api) do
    current_date_time = ~U[2000-01-01 21:30:00Z]

    with {:ok, response} <- weather_api.get_forecast(coordinates, :today),
         {:ok, weather_report} <- WeatherApi.Response.to_weather_report(response),
         weather_report_for_today <-
           WeatherReport.filter_by_same_day(weather_report, current_date_time),
         %Weather{} = weather <-
           Precipitation.determine_most_intense_precipitation_condition(weather_report_for_today) do
      {:ok, weather}
    end
  end
end
