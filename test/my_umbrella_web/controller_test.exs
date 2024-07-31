defmodule MyUmbrellaWeb.ControllerTest do
  use MyUmbrella.ConnCase, async: true

  alias MyUmbrella.Controls.Calendar.CurrentDateTime, as: CurrentDateTimeControl
  alias MyUmbrella.Controls.Coordinates, as: CoordinatesControl

  alias MyUmbrellaWeb.Controller

  describe "determining if an umbrella is required today" do
    test "given it IS raining before end-of-day; then an umbrella IS needed", %{conn: conn} do
      london = CoordinatesControl.example(:london)
      current_date_time_utc = CurrentDateTimeControl.Utc.example(:london)
      conn = Plug.Conn.assign(conn, :current_date_time_utc, current_date_time_utc)

      conn = Controller.show(conn, to_params(london))

      assert {200, _headers, body} = Plug.Test.sent_resp(conn)
      assert body =~ "Yes"
    end

    test "given it IS NOT raining before end-of-day; then an umbrella IS NOT needed", %{
      conn: conn
    } do
      orlando = CoordinatesControl.example(:orlando)
      current_date_time_utc = CurrentDateTimeControl.Utc.example(:orlando)
      conn = Plug.Conn.assign(conn, :current_date_time_utc, current_date_time_utc)

      conn = Controller.show(conn, to_params(orlando))

      assert {200, _headers, body} = Plug.Test.sent_resp(conn)
      assert body =~ "No"
    end
  end

  defp to_params({lat, lon}) do
    %{"lat" => to_string(lat), "lon" => to_string(lon)}
  end
end
