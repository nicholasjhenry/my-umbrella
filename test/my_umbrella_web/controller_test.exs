defmodule MyUmbrellaWeb.ControllerTest do
  use MyUmbrella.ConnCase, async: true

  alias MyUmbrellaWeb.Controller

  import Mox
  import MyUmbrella.Fixtures
  import MyUmbrella.Fixtures.WeatherApi

  describe "determining if an umbrella is required today" do
    test "given it IS raining before end-of-day; then an umbrella IS needed", %{conn: conn} do
      london = coordinates_fixture(:london)
      time_zone_utc = "Etc/UTC"
      current_date_time_utc = DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], time_zone_utc)
      conn = Plug.Conn.assign(conn, :current_date_time_utc, current_date_time_utc)

      stub(MyUmbrella.WeatherApi.Mock, :get_forecast, fn _coordinates, :today, _test_server_url ->
        response_fixture(:precipitation, london, time_zone_utc)
      end)

      conn = Controller.show(conn, to_params(london))

      assert {200, _headers, body} = Plug.Test.sent_resp(conn)
      assert body =~ "Yes"
    end

    test "given it IS NOT raining before end-of-day; then an umbrella IS NOT needed", %{
      conn: conn
    } do
      orlando = coordinates_fixture(:orlando)
      time_zone_new_york = "America/New_York"

      current_date_time_utc =
        DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], time_zone_new_york)
        |> DateTime.shift_zone!("Etc/UTC")

      conn = Plug.Conn.assign(conn, :current_date_time_utc, current_date_time_utc)

      stub(MyUmbrella.WeatherApi.Mock, :get_forecast, fn _coordinates, :today, _test_server_url ->
        response_fixture(:no_precipitation, orlando, time_zone_new_york)
      end)

      conn = Controller.show(conn, to_params(orlando))

      assert {200, _headers, body} = Plug.Test.sent_resp(conn)
      assert body =~ "No"
    end

    test "given an HTTP error; then responds with an error", %{conn: conn} do
      london = coordinates_fixture(:london)
      time_zone_utc = "Etc/UTC"
      current_date_time_utc = DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], time_zone_utc)
      conn = Plug.Conn.assign(conn, :current_date_time_utc, current_date_time_utc)

      stub(MyUmbrella.WeatherApi.Mock, :get_forecast, fn _coordinates, :today, _test_server_url ->
        response_fixture(:error, london, time_zone_utc)
      end)

      conn = Controller.show(conn, to_params(london))

      assert {401, _headers, _body} = Plug.Test.sent_resp(conn)
    end
  end

  defp to_params({lat, lon}) do
    %{"lat" => to_string(lat), "lon" => to_string(lon)}
  end
end
