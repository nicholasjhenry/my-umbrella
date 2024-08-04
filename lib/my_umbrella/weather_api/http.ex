defmodule MyUmbrella.WeatherApi.Http do
  @moduledoc false

  @behaviour MyUmbrella.WeatherApi.Behaviour

  @request_path "/data/3.0/onecall"
  @exclude_query URI.encode("exclude=minutely,daily,alerts")
  @default_url URI.parse("https://api.openweathermap.org")

  @impl true
  def get_forecast(coordinates, :today, base_url) do
    url = build_url(coordinates, base_url)

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200} = response} ->
        {:ok, Jason.decode!(response.body)}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, {:status, status_code}}
    end
  end

  defp build_url(coordinates, base_url) do
    base_url = base_url || @default_url
    encoded_app_id = get_app_id() |> URI.encode()

    base_url
    |> URI.append_path(@request_path)
    |> URI.append_query(@exclude_query)
    |> URI.append_query("appid=#{encoded_app_id}")
    |> append_coorindates_query(coordinates)
    |> URI.to_string()
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
