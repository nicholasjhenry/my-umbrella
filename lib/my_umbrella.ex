defmodule MyUmbrella do
  @moduledoc """
  A context module.
  """

  alias MyUmbrella
  alias MyUmbrella.Coordinates
  alias MyUmbrella.Precipitation
  alias MyUmbrella.WeatherReport

  alias MyUmbrella.Infrastructure.JsonHttp
  alias MyUmbrella.Infrastructure.WeatherApi

  alias MyUmbrella.Controls.Infrastructure.WeatherApi, as: WeatherApiControls

  @type t() :: %MyUmbrella{
          weather_api_client: WeatherApi.Client.t()
        }
  defstruct [:weather_api_client]

  @spec create :: t()
  def create do
    %MyUmbrella{weather_api_client: WeatherApi.Client.create()}
  end

  @spec create_null :: t()
  def create_null do
    %MyUmbrella{weather_api_client: WeatherApi.Client.create_null()}
  end

  def create_null(responses) do
    %MyUmbrella{weather_api_client: WeatherApi.Client.create_null(responses.weather_api)}
  end

  @spec for_today(t(), Coordinates.t()) :: {:ok, Precipitation.t()} | {:error, term}
  @spec for_today(t(), Coordinates.t(), DateTime.t()) :: {:ok, Precipitation.t()} | {:error, term}
  def for_today(my_umbrella, coordinates, current_date_time_utc \\ DateTime.utc_now()) do
    with {:ok, response} <-
           WeatherApi.Client.get_forecast(my_umbrella.weather_api_client, coordinates, :today),
         {:ok, weather_report} <- WeatherApi.Response.to_weather_report(response),
         current_date_time_in_time_zone =
           DateTime.shift_zone!(current_date_time_utc, weather_report.time_zone),
         weather_report_for_today <-
           WeatherReport.filter_by_same_day(weather_report, current_date_time_in_time_zone) do
      maybe_precipitation =
        Precipitation.determine_most_intense_precipitation_condition(weather_report_for_today)

      {:ok, maybe_precipitation}
    end
  end

  defmodule NullResponses do
    @moduledoc false

    defstruct [:weather_api]

    def new do
      %__MODULE__{}
    end

    def with_preciptation(responses) do
      body = WeatherApiControls.Response.Success.example(:london)
      response = JsonHttp.Response.new(status_code: 200, body: body)

      %{responses | weather_api: response}
    end

    def no_preciptation(responses) do
      body = WeatherApiControls.Response.Success.example(:orlando)
      response = JsonHttp.Response.new(status_code: 200, body: body)

      %{responses | weather_api: response}
    end
  end
end
