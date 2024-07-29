defmodule MyUmbrella.WeatherApi.Behaviour do
  @moduledoc false

  alias MyUmbrella.WeatherApi.Response

  @type coordinates :: {float(), float()}

  @callback get_forecast(coordinates, duration :: :today, url :: URI.t() | nil) ::
              {:ok, Response.t()} | {:error, term}
end
