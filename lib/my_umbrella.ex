defmodule MyUmbrella do
  @moduledoc """
  A context module.
  """

  alias MyUmbrella.Coordinates
  alias MyUmbrella.Precipitation
  alias MyUmbrella.WeatherApi
  alias MyUmbrella.WeatherReport

  @spec for_today(Coordinates.t()) :: {:ok, Precipitation.t()} | {:error, term}
  def for_today(coordinates) do
    with {:ok, response} <- WeatherApi.get_forecast(coordinates, :today),
         {:ok, weather_report} <- WeatherApi.Response.to_weather_report(response),
         current_date_time =
           DateTime.shift_zone!(~U[2000-01-01 21:30:00Z], weather_report.time_zone),
         weather_report_for_today <-
           WeatherReport.filter_by_same_day(weather_report, current_date_time) do
      maybe_precipitation =
        Precipitation.determine_most_intense_precipitation_condition(weather_report_for_today)

      {:ok, maybe_precipitation}
    end
  end
end
