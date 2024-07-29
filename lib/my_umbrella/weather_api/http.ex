defmodule MyUmbrella.WeatherApi.Http do
  @moduledoc false

  @behaviour MyUmbrella.WeatherApi.Behaviour

  @request_path "/data/3.0/onecall"
  @exclude_query URI.encode("exclude=minutely,daily,alerts")
  @default_url URI.parse("https://api.openweathermap.org")

  @impl true
  def get_forecast(coordinates, :today, url) do
    url = url || @default_url
    encoded_app_id = get_app_id() |> URI.encode()

    request =
      url
      |> URI.append_path(@request_path)
      |> URI.append_query(@exclude_query)
      |> URI.append_query("appid=#{encoded_app_id}")
      |> append_coorindates_query(coordinates)
      |> URI.to_string()

    case HTTPoison.get(request) do
      {:ok, %HTTPoison.Response{status_code: 200} = response} ->
        {:ok, Jason.decode!(response.body)}
    end
  end

  defp append_coorindates_query(uri, {lat, lon}) do
    lat_query = URI.encode("lat=#{lat}")
    lon_query = URI.encode("lon=#{lon}")

    uri
    |> URI.append_query(lat_query)
    |> URI.append_query(lon_query)
  end

  defp get_app_id do
    Application.fetch_env!(:my_umbrella, :open_weather_map) |> Keyword.fetch!(:app_id)
  end
end
