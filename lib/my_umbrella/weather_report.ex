defmodule MyUmbrella.WeatherReport do
  @moduledoc """
  A form of communication for forecasting atmospheric conditions, precipitation, and
  wind patterns, for specific coordinates and time.
  """
  alias MyUmbrella.Coordinates

  @enforce_keys [:coordinates, :date_time, :condition, :code]

  defstruct [:coordinates, :date_time, :condition, :code]

  @type condition :: :atmosphere | :clear | :clouds | :drizzle | :rain | :snow | :thunderstorm
  @type period :: :today

  @type t :: %__MODULE__{
          coordinates: Coordinates.t(),
          date_time: DateTime.t(),
          condition: condition(),
          code: integer()
        }

  @precipitation_conditions [
    snow: 600..622,
    thunderstorm: 200..232,
    rain: 500..531,
    drizzle: 300..321
  ]

  @spec filter_by_same_day([t()], DateTime.t()) :: list(t())
  def filter_by_same_day(weather_reports, current_date_time) do
    target_date = DateTime.to_date(current_date_time)
    Enum.filter(weather_reports, &same_day?(&1.date_time, target_date))
  end

  defp same_day?(date_time, target_date) do
    date = DateTime.to_date(date_time)

    Date.compare(date, target_date) == :eq
  end

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
      DateTime.compare(lhs.date_time, rhs.date_time) == :eq &&
      lhs.condition == rhs.condition &&
      lhs.code == rhs.code
  end
end
