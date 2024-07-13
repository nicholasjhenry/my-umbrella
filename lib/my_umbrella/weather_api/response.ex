defmodule MyUmbrella.WeatherApi.Response do
  @moduledoc """
  The type representing a response from the weather api.
  """

  @type t :: map()

  alias MyUmbrella.Coordinates
  alias MyUmbrella.Weather

  @spec to_weather(t()) :: {:ok, list(Weather.t())}
  def to_weather(%{"current" => current, "hourly" => hourly} = response) do
    current_data = parse_forecast(response, current)
    forecast_data = Enum.map(hourly, &parse_forecast(response, &1))

    {:ok, [current_data | forecast_data]}
  end

  def to_weather(_response) do
    clear = 800
    weather_data = [%Weather{datetime: ~U[1970-01-01 00:00:00Z], code: clear}]

    {:ok, weather_data}
  end

  defp parse_forecast(response, forecast) do
    %{"lat" => lat, "lon" => lon} = response
    coordinates = Coordinates.new(lat, lon)
    weather_datetime = forecast |> Map.fetch!("dt") |> DateTime.from_unix!()
    weather_code = forecast |> Map.fetch!("weather") |> List.first() |> Map.fetch!("id")

    %Weather{coordinates: coordinates, datetime: weather_datetime, code: weather_code}
  end
end
