defmodule MyUmbrella.WeatherApi.Behaviour do
  @moduledoc false

  alias MyUmbrella.WeatherApi.Response

  @type coordinates :: {float(), float()}

  @callback get_forecast(coordinates, duration :: :today) :: {:ok, Response.t()} | {:error, term}
end
