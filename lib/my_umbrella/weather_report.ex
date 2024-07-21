defmodule MyUmbrella.WeatherReport do
  @moduledoc """
  A form of communication for forecasting atmospheric conditions, precipitation, and
  wind patterns, for specific coordinates and time.
  """
  alias MyUmbrella.Coordinates
  alias MyUmbrella.Weather

  @enforce_keys [:coordinates, :timezone]

  defstruct coordinates: nil, timezone: nil, weather: []

  @type condition :: :atmosphere | :clear | :clouds | :drizzle | :rain | :snow | :thunderstorm

  @type t :: %__MODULE__{
          coordinates: Coordinates.t(),
          timezone: Calendar.time_zone(),
          weather: list(Weather.t())
        }

  @spec new(Enumerable.t()) :: t()
  def new(attrs) do
    struct!(__MODULE__, attrs)
  end

  @spec add_weather(t(), Enumerable.t()) :: t()
  def add_weather(weather_report, attrs) do
    weather = struct!(Weather, attrs)
    weather = [weather | weather_report.weather]
    %{weather_report | weather: weather}
  end

  @spec filter_by_same_day(t(), DateTime.t()) :: t()
  def filter_by_same_day(weather_report, current_date_time) do
    target_date = DateTime.to_date(current_date_time)
    filtered_weather = Enum.filter(weather_report.weather, &same_day?(&1.date_time, target_date))
    %{weather_report | weather: filtered_weather}
  end

  defp same_day?(date_time, target_date) do
    date = DateTime.to_date(date_time)

    Date.compare(date, target_date) == :eq
  end
end
