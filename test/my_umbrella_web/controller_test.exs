defmodule MyUmbrellaWeb.ControllerTest do
  use MyUmbrella.ConnCase, async: true

  alias MyUmbrella.Controls.Coordinates, as: CoordinatesControl
  alias MyUmbrella.Infrastructure.Calendar.Controls.DateTime, as: DateTimeControl
  alias MyUmbrella.Infrastructure.WeatherApi.Controls, as: WeatherApiControls

  alias MyUmbrellaWeb.Controller

  describe "determining if an umbrella is required today" do
    test "given it IS raining before end-of-day; then an umbrella IS needed", %{conn: conn} do
      london = CoordinatesControl.example(:london)
      current_date_time_utc = DateTimeControl.Utc.example(:london)

      my_umbrella =
        MyUmbrella.create_null(%{
          weather_api_client: WeatherApiControls.Response.Success.example(:london)
        })

      determine_if_umbrella_need(conn, my_umbrella, london, current_date_time_utc)

      assert {200, _headers, body} = Plug.Test.sent_resp(conn)
      assert body =~ "Yes"
    end

    test "given it IS NOT raining before end-of-day; then an umbrella IS NOT needed", %{
      conn: conn
    } do
      orlando = CoordinatesControl.example(:orlando)
      current_date_time_utc = DateTimeControl.Utc.example(:orlando)

      my_umbrella =
        MyUmbrella.create_null(%{
          weather_api_client: WeatherApiControls.Response.Success.example(:orlando)
        })

      determine_if_umbrella_need(conn, my_umbrella, orlando, current_date_time_utc)

      assert {200, _headers, body} = Plug.Test.sent_resp(conn)
      assert body =~ "No"
    end
  end

  defp determine_if_umbrella_need(conn, my_umbrella, coordinates, date_time) do
    conn
    |> Plug.Conn.assign(:current_date_time_utc, date_time)
    |> Plug.Conn.assign(:my_umbrella, my_umbrella)
    |> Controller.show(to_params(coordinates))
  end

  defp to_params({lat, lon}) do
    %{"lat" => to_string(lat), "lon" => to_string(lon)}
  end
end
