defmodule MyUmbrella do
  @moduledoc """
  A context module.
  """

  alias MyUmbrella
  alias MyUmbrella.Coordinates
  alias MyUmbrella.Precipitation
  alias MyUmbrella.WeatherReport

  alias MyUmbrella.Infrastructure.WeatherApi

  @type t() :: %MyUmbrella{
          weather_api_client: WeatherApi.Client.t()
        }
  defstruct [:weather_api_client]

  @type responses :: %{
          weather_api: WeatherApi.Response.t()
        }

  @spec create() :: t()
  def create do
    %MyUmbrella{weather_api_client: WeatherApi.Client.create()}
  end

  @spec create_null() :: t()
  @spec create_null(responses()) :: t()
  def create_null do
    %MyUmbrella{weather_api_client: WeatherApi.Client.create_null()}
  end

  def create_null(responses) do
    null_weather_client = WeatherApi.Client.create_null(%{http_client: responses.weather_api})
    %MyUmbrella{weather_api_client: null_weather_client}
  end

  @spec for_today(t(), Coordinates.t()) :: {:ok, Precipitation.t()} | {:error, term}
  @spec for_today(t(), Coordinates.t(), DateTime.t()) :: {:ok, Precipitation.t()} | {:error, term}
  def for_today(my_umbrella, coordinates, current_date_time_utc \\ DateTime.utc_now()) do
    with {:ok, response} <-
           WeatherApi.Client.get_forecast(my_umbrella.weather_api_client, coordinates, :today),
         {:ok, weather_report} <- WeatherApi.ResponseBody.to_weather_report(response),
         current_date_time_in_time_zone =
           DateTime.shift_zone!(current_date_time_utc, weather_report.time_zone),
         weather_report_for_today <-
           WeatherReport.filter_by_same_day(weather_report, current_date_time_in_time_zone) do
      maybe_precipitation =
        Precipitation.determine_most_intense_precipitation_condition(weather_report_for_today)

      {:ok, maybe_precipitation}
    end
  end
end
