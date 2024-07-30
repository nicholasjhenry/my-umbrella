defmodule MyUmbrellaTest do
  use MyUmbrella.TestCase, async: true

  alias MyUmbrella.Coordinates
  alias MyUmbrella.Weather

  describe "determine if an umbrella is needed today" do
    test "given it IS raining before end-of-day; then an umbrella IS needed" do
      london = Coordinates.new(51.5098, -0.118)
      current_date_time_utc = DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], "Etc/UTC")

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

      weather_result = MyUmbrella.for_today(orlando, current_date_time_utc)

      assert {:ok, :no_precipitation} == weather_result
    end
  end
end
