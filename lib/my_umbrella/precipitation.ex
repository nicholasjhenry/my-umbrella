defmodule MyUmbrella.Precipitation do
  @moduledoc """
  Hydrometeorological phenomena involving any form of water, liquid or solid, that
  falls from the atmosphere and reaches the ground, such as rain, snow, sleet, or hail.
  """

  alias MyUmbrella.Weather
  alias MyUmbrella.WeatherReport

  @type t :: {:precipitation, Weather.t()} | :no_precipitation

  @precipitation_conditions [
    snow: 600..622,
    thunderstorm: 200..232,
    rain: 500..531,
    drizzle: 300..321
  ]

  @spec determine_most_intense_precipitation_condition(WeatherReport.t()) :: t()
  def determine_most_intense_precipitation_condition(weather_report) do
    maybe_weather =
      weather_report.weather
      |> Enum.filter(&preciptation?/1)
      |> Enum.sort_by(& &1, {:desc, __MODULE__})
      |> List.first()

    case maybe_weather do
      %Weather{} = weather ->
        {:precipitation, weather}

      nil ->
        :no_precipitation
    end
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
