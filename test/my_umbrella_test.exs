defmodule MyUmbrellaTest do
  use MyUmbrella.TestCase, async: true

  alias MyUmbrella.Coordinates
  alias MyUmbrella.Weather

  import Mox
  import MyUmbrella.Fixtures.WeatherApi

  setup :verify_on_exit!

  describe "determine if an umbrella is needed today" do
    test "given it IS raining before end-of-day; then an umbrella IS needed" do
      london = Coordinates.new(51.5098, -0.118)
      time_zone_utc = "Etc/UTC"
      current_date_time_utc = DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], time_zone_utc)

      expect(MyUmbrella.WeatherApi.Mock, :get_forecast, fn coordinates,
                                                           :today,
                                                           _test_server_url ->
        assert london == coordinates
        response_fixture(:precipitation, coordinates, time_zone_utc)
      end)

      weather_result = MyUmbrella.for_today(london, current_date_time_utc)

      expected_weather =
        Weather.new(date_time: ~U[2000-01-01 22:00:00Z], condition: :rain, code: 501)

      assert {:ok, {:precipitation, actual_weather}} = weather_result
      assert Weather.eq?(actual_weather, expected_weather)
    end

    test "given it IS NOT raining before end-of-day; then an umbrella IS NOT needed" do
      orlando = Coordinates.new(28.5383, -81.3792)
      time_zone_new_york = "America/New_York"

      current_date_time_utc =
        DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], time_zone_new_york)
        |> DateTime.shift_zone!("Etc/UTC")

      expect(MyUmbrella.WeatherApi.Mock, :get_forecast, fn coordinates,
                                                           :today,
                                                           _test_server_url ->
        assert orlando == coordinates
        response_fixture(:no_precipitation, coordinates, time_zone_new_york)
      end)

      weather_result = MyUmbrella.for_today(orlando, current_date_time_utc)

      assert {:ok, :no_precipitation} == weather_result
    end

    test "given an HTTP response with an error; then the error is returned" do
      london = Coordinates.new(51.5098, -0.118)
      time_zone_utc = "Etc/UTC"
      current_date_time_utc = DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], time_zone_utc)

      expect(MyUmbrella.WeatherApi.Mock, :get_forecast, fn _coordinates,
                                                           :today,
                                                           _test_server_url ->
        response_fixture(:error, london, time_zone_utc)
      end)

      weather_result = MyUmbrella.for_today(london, current_date_time_utc)

      assert {:error, {:status, 401}} == weather_result
    end
  end
end
