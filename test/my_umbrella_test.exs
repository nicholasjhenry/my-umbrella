defmodule MyUmbrellaTest do
  use MyUmbrella.TestCase, async: true

  alias MyUmbrella.Coordinates
  alias MyUmbrella.Weather

  import Mox

  setup :verify_on_exit!

  describe "determine if an umbrella is needed today" do
    test "given it IS raining before end-of-day; then an umbrella IS needed" do
      london = Coordinates.new(51.5098, -0.118)
      current_date_time_utc = DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], "Etc/UTC")

      expect(MyUmbrella.WeatherApi.Mock, :get_forecast, fn coordinates,
                                                           :today,
                                                           _test_server_url ->
        assert london == coordinates
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

      weather_result = MyUmbrella.for_today(london, current_date_time_utc)

      expected_weather =
        Weather.new(date_time: ~U[2000-01-01 22:00:00Z], condition: :rain, code: 501)

      assert {:ok, {:precipitation, actual_weather}} = weather_result
      assert Weather.eq?(actual_weather, expected_weather)
    end

    test "given it IS NOT raining before end-of-day; then an umbrella IS NOT needed" do
      orlando = Coordinates.new(28.5383, -81.3792)

      current_date_time_utc =
        DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], "America/New_York")
        |> DateTime.shift_zone!("Etc/UTC")

      expect(MyUmbrella.WeatherApi.Mock, :get_forecast, fn coordinates,
                                                           :today,
                                                           _test_server_url ->
        assert orlando == coordinates
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

      weather_result = MyUmbrella.for_today(orlando, current_date_time_utc)

      assert {:ok, :no_precipitation} == weather_result
    end

    test "given an HTTP response with an error; then the error is returned" do
      orlando = Coordinates.new(28.5383, -81.3792)

      current_date_time_utc =
        DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], "America/New_York")
        |> DateTime.shift_zone!("Etc/UTC")

      expect(MyUmbrella.WeatherApi.Mock, :get_forecast, fn _coordinates,
                                                           :today,
                                                           _test_server_url ->
        not_authorized = {:status, 401}

        {:error, not_authorized}
      end)

      weather_result = MyUmbrella.for_today(orlando, current_date_time_utc)

      assert {:error, {:status, 401}} == weather_result
    end
  end
end
