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
  alias MyUmbrella.Weather
  alias MyUmbrella.WeatherReport

  @spec to_weather_report(t()) :: {:ok, WeatherReport.t()}
  def to_weather_report(%{"current" => current, "hourly" => hourly} = response) do
    weather_report = parse_weather_report(response)
    current_weather = parse_weather(current)
    forecasted_weather = Enum.map(hourly, &parse_weather(&1))

    {:ok, %{weather_report | weather: [current_weather | forecasted_weather]}}
  end

  def to_weather_report(_response) do
    london = Coordinates.new(51.5098, -0.118)

    weather = %Weather{
      date_time: ~U[1970-01-01 00:00:00Z],
      condition: :clear,
      code: 800
    }

    weather_report = %WeatherReport{
      coordinates: london,
      weather: [weather]
    }

    {:ok, weather_report}
  end

  defp parse_weather_report(response) do
    %{"lat" => lat, "lon" => lon} = response
    coordinates = Coordinates.new(lat, lon)
    %WeatherReport{coordinates: coordinates}
  end

  defp parse_weather(forecast) do
    weather_date_time = forecast |> Map.fetch!("dt") |> DateTime.from_unix!()
    weather_code = forecast |> Map.fetch!("weather") |> List.first() |> Map.fetch!("id")

    {weather_condition, _codes} =
      Enum.find(@conditions, fn {_condition, codes} -> weather_code in codes end)

    %Weather{
      date_time: weather_date_time,
      condition: weather_condition,
      code: weather_code
    }
  end
end
