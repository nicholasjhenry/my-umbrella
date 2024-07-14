defmodule MyUmbrella.WeatherApi.Response do
  @moduledoc """
  The type representing a response from the weather api.
  """

  @type t :: map()

  # https://openweathermap.org/weather-conditions
  #
  @conditions [
    thunderstorm: 200..232,
    drizzle: 300..321,
    rain: 500..531,
    snow: 600..622,
    atmosphere: 701..781,
    clear: 800..800,
    clouds: 801..804
  ]

  alias MyUmbrella.Coordinates
  alias MyUmbrella.WeatherReport

  @spec to_weather(t()) :: {:ok, list(WeatherReport.t())}
  def to_weather(%{"current" => current, "hourly" => hourly} = response) do
    current_data = parse_forecast(response, current)
    forecast_data = Enum.map(hourly, &parse_forecast(response, &1))

    {:ok, [current_data | forecast_data]}
  end

  def to_weather(_response) do
    london = Coordinates.new(51.5098, -0.118)

    weather = %WeatherReport{
      coordinates: london,
      datetime: ~U[1970-01-01 00:00:00Z],
      condition: :clear,
      code: 800
    }

    {:ok, [weather]}
  end

  defp parse_forecast(response, forecast) do
    %{"lat" => lat, "lon" => lon} = response
    coordinates = Coordinates.new(lat, lon)
    weather_datetime = forecast |> Map.fetch!("dt") |> DateTime.from_unix!()
    weather_code = forecast |> Map.fetch!("weather") |> List.first() |> Map.fetch!("id")

    {weather_condition, _codes} =
      Enum.find(@conditions, fn {_condition, codes} -> weather_code in codes end)

    %WeatherReport{
      coordinates: coordinates,
      datetime: weather_datetime,
      condition: weather_condition,
      code: weather_code
    }
  end
end
