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

  @spec determine_most_intense_precipitation_condition(list(t())) :: t() | nil
  def determine_most_intense_precipitation_condition(weather_reports) do
    weather_reports
    |> Enum.filter(&preciptation?/1)
    |> Enum.sort_by(& &1, {:desc, __MODULE__})
    |> List.first()
  end

  defp preciptation?(weather) do
    @precipitation_conditions
    |> Keyword.values()
    |> Enum.any?(&(weather.code in &1))
  end

  @spec compare(t, t) :: :eq | :gt | :lt
  def compare(lhs, rhs) do
    weighted_condition =
      @precipitation_conditions
      |> Enum.reverse()
      |> Enum.with_index(fn {key, _value}, index -> {key, index} end)
      |> Map.new()

    lhs_weight = Map.fetch!(weighted_condition, lhs.condition)
    rhs_weight = Map.fetch!(weighted_condition, rhs.condition)

    cond do
      lhs_weight == rhs_weight -> :eq
      lhs_weight > rhs_weight -> :gt
      lhs_weight < rhs_weight -> :lt
    end
  end

  @spec eq?(t(), t()) :: boolean()
  def eq?(lhs, rhs) do
    lhs.coordinates == rhs.coordinates &&
      DateTime.compare(lhs.datetime, rhs.datetime) == :eq &&
      lhs.code == rhs.code
  end
end
