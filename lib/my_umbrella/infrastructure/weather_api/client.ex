defmodule MyUmbrella.Infrastructure.WeatherApi.Client do
  @moduledoc """
  An high-level infrastructure wrapper for Open Weather Map to get weather forecasts.

  - Current and forecasts weather data: https://openweathermap.org/api/one-call-3#current
  - Weather Conditions: https://openweathermap.org/weather-conditions
  """

  alias MyUmbrella.Infrastructure.JsonHttp
  alias MyUmbrella.Infrastructure.WeatherApi

  alias MyUmbrella.Controls.Infrastructure.WeatherApi, as: WeatherApiControls

  @type t() :: %WeatherApi.Client{
          http_client: JsonHttp.Client.t()
        }

  defstruct [:http_client, :app_id]

  @type coordinates :: {float(), float()}

  @default_url "https://api.openweathermap.org"
  @request_path "/data/3.0/onecall"
  @exclude_query "exclude=minutely,daily,alerts"

  @spec get_forecast(t(), coordinates, duration :: :today) :: {:ok, WeatherApi.Response.t()}
  def get_forecast(weather_api_client, coordinates, :today) do
    encoded_app_id = weather_api_client.app_id |> URI.encode()

    url =
      @default_url
      |> URI.parse()
      |> URI.append_path(@request_path)
      |> URI.append_query(URI.encode(@exclude_query))
      |> URI.append_query("appid=#{encoded_app_id}")
      |> append_coorindates_query(coordinates)
      |> URI.to_string()

    case JsonHttp.Client.get(weather_api_client.http_client, url) do
      {:ok, %JsonHttp.Response{status_code: 200} = response} ->
        {:ok, response.body}

      {:ok, %JsonHttp.Response{status_code: status_code}} ->
        {:error, {:status, status_code}}
    end
  end

  defp append_coorindates_query(uri, {lat, lon}) do
    lat_query = URI.encode("lat=#{lat}")
    lon_query = URI.encode("lon=#{lon}")

    uri
    |> URI.append_query(lat_query)
    |> URI.append_query(lon_query)
  end

  @spec create() :: t()
  def create do
    %WeatherApi.Client{
      http_client: JsonHttp.Client.create(),
      app_id: get_app_id()
    }
  end

  @spec create_null() :: t()
  @spec create_null(Http.Response.t()) :: t()
  def create_null do
    responses = %{http_client: WeatherApiControls.Response.Success.example(:london)}

    create_null(responses)
  end

  def create_null(responses) do
    http_client_responses = [{@default_url <> @request_path, responses.http_client}]

    %WeatherApi.Client{
      http_client: JsonHttp.Client.create_null(http_client_responses),
      app_id: get_app_id()
    }
  end

  defp get_app_id do
    Application.fetch_env!(:my_umbrella, :open_weather_map) |> Keyword.fetch!(:app_id)
  end
end
