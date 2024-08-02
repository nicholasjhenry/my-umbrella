defmodule MyUmbrella.Infrastructure.WeatherApi.Response do
  @moduledoc """
  The type representing a response from the weather api.
  """

  alias MyUmbrella.Infrastructure.JsonHttp
  alias MyUmbrella.Infrastructure.WeatherApi

  @type t :: JsonHttp.Response.t(WeatherApi.ResponseBody.t())

  @spec new(WeatherApi.ResponseBody.t()) :: t()
  def new(body) do
    JsonHttp.Response.new(status_code: 200, body: body)
  end
end
