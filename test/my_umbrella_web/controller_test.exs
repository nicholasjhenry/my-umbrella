defmodule MyUmbrellaWeb.ControllerTest do
  use MyUmbrella.ConnCase, async: true

  alias MyUmbrellaWeb.Controller

  import Mox
  import MyUmbrella.Fixtures
  import MyUmbrella.Fixtures.WeatherApi

  describe "determining if an umbrella is required today" do
    test "given it IS raining before end-of-day; then an umbrella IS needed", %{conn: conn} do
      london = coordinates_fixture(:london)
      current_date_time = date_time_fixture(:london)

      conn = determine_if_umbrella_needed_today(conn, :precipitation, london, current_date_time)

      assert {200, _headers, body} = Plug.Test.sent_resp(conn)
      assert body =~ "Yes"
    end

    test "given it IS NOT raining before end-of-day; then an umbrella IS NOT needed", %{
      conn: conn
    } do
      orlando = coordinates_fixture(:orlando)
      current_date_time = date_time_fixture(:orlando)

      conn =
        determine_if_umbrella_needed_today(conn, :no_precipitation, orlando, current_date_time)

      assert {200, _headers, body} = Plug.Test.sent_resp(conn)
      assert body =~ "No"
    end

    test "given an HTTP error; then responds with an error", %{conn: conn} do
      london = coordinates_fixture(:london)
      current_date_time = date_time_fixture(:london)

      conn = determine_if_umbrella_needed_today(conn, :error, london, current_date_time)

      assert {401, _headers, _body} = Plug.Test.sent_resp(conn)
    end

    test "given an error; then responds with an error", %{conn: conn} do
      london = coordinates_fixture(:london)
      current_date_time = date_time_fixture(:london)

      conn = determine_if_umbrella_needed_today(conn, :critical_error, london, current_date_time)

      assert {500, _headers, body} = Plug.Test.sent_resp(conn)
      assert body =~ "nxdomain"
    end
  end

  defp determine_if_umbrella_needed_today(
         conn,
         maybe_precipitation,
         coordinates,
         current_date_time
       ) do
    stub(MyUmbrella.WeatherApi.Mock, :get_forecast, fn _coordinates, :today, _test_server_url ->
      response_fixture(maybe_precipitation, coordinates, current_date_time.time_zone)
    end)

    current_date_time_utc = DateTime.shift_zone!(current_date_time, "Etc/UTC")

    conn
    |> Plug.Conn.assign(:current_date_time_utc, current_date_time_utc)
    |> Controller.show(to_params(coordinates))
  end

  defp to_params({lat, lon}) do
    %{"lat" => to_string(lat), "lon" => to_string(lon)}
  end
end
