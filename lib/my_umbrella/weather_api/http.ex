defmodule MyUmbrella.WeatherApi.Http do
  @moduledoc false

  @behaviour MyUmbrella.WeatherApi.Behaviour

  @impl true
  def get_forecast(_coordinates, :today) do
    {:ok, %{"error" => "no implemented"}}
  end
end
