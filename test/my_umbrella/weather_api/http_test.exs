defmodule MyUmbrella.WeatherApi.HttpTest do
  use MyUmbrella.TestCase, async: false

  alias MyUmbrella.Coordinates
  alias MyUmbrella.WeatherApi

  setup do
    Mox.stub_with(MyUmbrella.WeatherApi.Mock, MyUmbrella.WeatherApi.Http)

    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "getting a forecast" do
    test "handles a response with a success status code", %{
      bypass: bypass,
      fixture_path: fixture_path
    } do
      test_server_url = URI.parse("http://localhost:#{bypass.port}")

      fixture_pathname = Path.join([fixture_path, "response/success.json"])
      response = fixture_pathname |> File.read!() |> :json.decode()

      Bypass.expect_once(bypass, "GET", "/data/3.0/onecall", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)

        assert conn.query_params["exclude"] == "minutely,daily,alerts"
        assert conn.query_params["lat"] == "51.5098"
        assert conn.query_params["lon"] == "-0.118"
        assert conn.query_params["appid"] == "OPEN_WEATHER_MAP_APP_ID_FAKE"

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, Jason.encode!(response))
      end)

      london = Coordinates.new(51.5098, -0.118)
      result = WeatherApi.get_forecast(london, :today, test_server_url)

      assert {:ok, data} = result
      assert %{"current" => _current, "hourly" => _hourly} = data
    end

    test "handles a response with an error status code", %{
      bypass: bypass,
      fixture_path: fixture_path
    } do
      test_server_url = URI.parse("http://localhost:#{bypass.port}")

      fixture_pathname = Path.join([fixture_path, "response/unauthorized.json"])
      response = fixture_pathname |> File.read!() |> :json.decode()

      Bypass.expect_once(bypass, "GET", "/data/3.0/onecall", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(401, Jason.encode!(response))
      end)

      london = Coordinates.new(51.5098, -0.118)
      result = WeatherApi.get_forecast(london, :today, test_server_url)

      assert {:error, {:status, 401}} == result
    end
  end
end
