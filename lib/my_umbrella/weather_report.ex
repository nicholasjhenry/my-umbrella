defmodule MyUmbrella.WeatherReport do
  @moduledoc """
  A form of communication for forecasting atmospheric conditions, precipitation, and
  wind patterns, for a specific location and time.
  """
  alias MyUmbrella.Coordinates

  @enforce_keys [:coordinates, :datetime, :condition, :code]

  defstruct [:coordinates, :datetime, :condition, :code]

  @type condition :: :atmosphere | :clear | :clouds | :drizzle | :rain | :snow | :thunderstorm

  @type t :: %__MODULE__{
          coordinates: Coordinates.t(),
          datetime: DateTime.t(),
          condition: condition(),
          code: integer()
        }

  @precipitation_conditions [
    snow: 600..622,
    thunderstorm: 200..232,
    rain: 500..531,
    drizzle: 300..321
  ]

  @spec eq?(t(), t()) :: boolean()
  def eq?(lhs, rhs) do
    lhs.coordinates == rhs.coordinates &&
      DateTime.compare(lhs.datetime, rhs.datetime) == :eq &&
      lhs.code == rhs.code
  end

  def determine_most_intense_precipitation_condition(weather_data) do
    weather_data
    |> Enum.filter(&perciptation?/1)
    |> List.first()
  end

  defp perciptation?(weather) do
    @precipitation_conditions
    |> Keyword.values()
    |> Enum.any?(&(weather.code in &1))
  end
end
