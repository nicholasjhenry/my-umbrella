defmodule MyUmbrellaTest do
  use MyUmbrella.TestCase, async: true

  alias MyUmbrella.Weather

  import Mox
  import MyUmbrella.Fixtures
  import MyUmbrella.Fixtures.WeatherApi

  setup :verify_on_exit!

  describe "determine if an umbrella is needed today" do
    test "given it IS raining before end-of-day; then an umbrella IS needed" do
      london = coordinates_fixture(:london)
      current_date_time = DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], "Etc/UTC")

      weather_result =
        determine_if_umbrella_needed_today(:precipitation, london, current_date_time)

      expected_weather =
        Weather.new(date_time: ~U[2000-01-01 22:00:00Z], condition: :rain, code: 501)

      assert {:ok, {:precipitation, actual_weather}} = weather_result
      assert Weather.eq?(actual_weather, expected_weather)
    end

    test "given it IS NOT raining before end-of-day; then an umbrella IS NOT needed" do
      orlando = coordinates_fixture(:orlando)
      current_date_time = DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], "America/New_York")

      weather_result =
        determine_if_umbrella_needed_today(:no_precipitation, orlando, current_date_time)

      assert {:ok, :no_precipitation} == weather_result
    end

    test "given an HTTP response with an error; then the error is returned" do
      london = coordinates_fixture(:london)
      current_date_time_utc = DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], "Etc/UTC")

      weather_result =
        determine_if_umbrella_needed_today(:error, london, current_date_time_utc)

      assert {:error, {:status, 401}} == weather_result
    end

    defp determine_if_umbrella_needed_today(
           maybe_precipitation,
           coordinates,
           current_date_time
         ) do
      current_date_time_utc = DateTime.shift_zone!(current_date_time, "Etc/UTC")

      expect(MyUmbrella.WeatherApi.Mock, :get_forecast, fn mock_coordinates,
                                                           :today,
                                                           _test_server_url ->
        assert coordinates == mock_coordinates
        response_fixture(maybe_precipitation, coordinates, current_date_time.time_zone)
      end)

      MyUmbrella.for_today(coordinates, current_date_time_utc)
    end
  end
end
