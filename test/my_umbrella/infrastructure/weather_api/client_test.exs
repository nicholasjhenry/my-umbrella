defmodule MyUmbrella.Infrastructure.WeatherApi.ClientTest do
  use MyUmbrella.TestCase, async: true

  alias MyUmbrella.Infrastructure.JsonHttp
  alias MyUmbrella.Infrastructure.WeatherApi

  alias MyUmbrella.Controls.Coordinates, as: CoordinatesControl
  alias MyUmbrella.Controls.Infrastructure.WeatherApi, as: WeatherApiControls

  alias Nullables.OutputTracking

  describe "getting a forecast" do
    test "handles a response with a success status code", %{test: test} do
      london = CoordinatesControl.example(:london)

      body = WeatherApiControls.Response.Success.example(:london)
      response = JsonHttp.Response.new(status_code: 200, body: body)

      ref = OutputTracking.track_output(test, [:http_client, :requests])

      result =
        response
        |> WeatherApi.Client.create_null()
        |> WeatherApi.Client.get_forecast(london, :today)

      assert {:ok, response} = result
      assert %{"current" => _current, "hourly" => _hourly} = response

      assert_received {[:http_client, :requests], ^ref, actual_request}
      assert url = URI.parse(actual_request.url)
      query_params = Plug.Conn.Query.decode(url.query)

      assert query_params["exclude"] == "minutely,daily,alerts"
      assert query_params["lat"] == "51.5098"
      assert query_params["lon"] == "-0.118"
      assert query_params["appid"] == "OPEN_WEATHER_MAP_APP_ID_FAKE"
    end

    test "handles a response with an error status code" do
      london = CoordinatesControl.example(:london)

      body = WeatherApiControls.Response.Success.example(:london)
      response = JsonHttp.Response.new(status_code: 401, body: body)

      result =
        response
        |> WeatherApi.Client.create_null()
        |> WeatherApi.Client.get_forecast(london, :today)

      assert {:error, {:status, 401}} == result
    end
  end
end
