defmodule MyUmbrellaWeb.ControllerTest do
  use MyUmbrella.ConnCase, async: true

  alias MyUmbrella.Coordinates

  alias MyUmbrellaWeb.Controller

  import Mox

  describe "determining if an umbrella is required today" do
    test "given it IS raining before end-of-day; then an umbrella IS needed", %{conn: conn} do
      london = Coordinates.new(51.5098, -0.118)
      current_date_time_utc = DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], "Etc/UTC")
      conn = Plug.Conn.assign(conn, :current_date_time_utc, current_date_time_utc)

      stub(MyUmbrella.WeatherApi.Mock, :get_forecast, fn coordinates, :today, _test_server_url ->
        {lat, lon} = coordinates

        response = %{
          "lat" => lat,
          "lon" => lon,
          "timezone" => "Etc/UTC",
          "current" => %{
            "dt" => 946_762_200,
            "weather" => [
              %{
                "id" => 802,
                "main" => "Clouds",
                "description" => "scattered clouds"
              }
            ]
          },
          "hourly" => [
            %{
              "dt" => 946_764_000,
              "weather" => [
                %{
                  "id" => 501,
                  "main" => "Rain",
                  "description" => "moderate rain"
                }
              ]
            }
          ]
        }

        {:ok, response}
      end)

      conn = Controller.show(conn, to_params(london))

      assert {200, _headers, body} = Plug.Test.sent_resp(conn)
      assert body =~ "Yes"
    end

    test "given it IS NOT raining before end-of-day; then an umbrella IS NOT needed", %{
      conn: conn
    } do
      orlando = Coordinates.new(28.5383, -81.3792)
      current_date_time_utc = DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], "Etc/UTC")
      conn = Plug.Conn.assign(conn, :current_date_time_utc, current_date_time_utc)

      stub(MyUmbrella.WeatherApi.Mock, :get_forecast, fn coordinates, :today, _test_server_url ->
        {lat, lon} = coordinates

        response = %{
          "lat" => lat,
          "lon" => lon,
          "timezone" => "America/New_York",
          "current" => %{
            "dt" => 946_762_200,
            "weather" => [
              %{
                "id" => 803,
                "main" => "Clouds",
                "description" => "broken clouds"
              }
            ]
          },
          "hourly" => [
            %{
              "dt" => 946_764_000,
              "weather" => [
                %{
                  "id" => 803,
                  "main" => "Clouds",
                  "description" => "broken clouds"
                }
              ]
            }
          ]
        }

        {:ok, response}
      end)

      conn = Controller.show(conn, to_params(orlando))

      assert {200, _headers, body} = Plug.Test.sent_resp(conn)
      assert body =~ "No"
    end

    test "given an HTTP error; then responds with an error", %{conn: conn} do
      london = Coordinates.new(51.5098, -0.118)
      current_date_time_utc = DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], "Etc/UTC")
      conn = Plug.Conn.assign(conn, :current_date_time_utc, current_date_time_utc)

      stub(MyUmbrella.WeatherApi.Mock, :get_forecast, fn _coordinates, :today, _test_server_url ->
        unauthorized = {:status, 401}

        {:error, unauthorized}
      end)

      conn = Controller.show(conn, to_params(london))

      assert {401, _headers, _body} = Plug.Test.sent_resp(conn)
    end
  end

  defp to_params({lat, lon}) do
    %{"lat" => to_string(lat), "lon" => to_string(lon)}
  end
end
