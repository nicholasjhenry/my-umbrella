defmodule MyUmbrella.WeatherApi do
  @moduledoc """
  An external dependency to get weather forecasts.
  """

  alias MyUmbrella.Weather

  @type location :: {float(), float()}

  @orlando {28.5383, -81.3792}

  @spec get_forecast(location, duration :: :today) :: list(Weather.t())
  def get_forecast(@orlando, :today) do
    clear = 800
    weather_data = [%Weather{datetime: ~U[1970-01-01 00:00:00Z], code: clear}]
    {:ok, weather_data}
  end
end
