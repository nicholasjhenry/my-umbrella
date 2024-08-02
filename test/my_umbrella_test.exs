defmodule MyUmbrellaTest do
  use MyUmbrella.TestCase, async: true

  alias MyUmbrella.Weather

  alias MyUmbrella.Controls.Calendar.CurrentDateTime, as: CurrentDateTimeControl
  alias MyUmbrella.Controls.Coordinates, as: CoordinatesControl
  alias MyUmbrella.Controls.Weather, as: WeatherControl

  describe "determine if an umbrella is needed today" do
    test "given it IS raining before end-of-day; then an umbrella IS needed" do
      london = CoordinatesControl.example(:london)
      current_date_time = CurrentDateTimeControl.Utc.example(:london)

      weather_result =
        MyUmbrella.NullResponses.new()
        |> MyUmbrella.NullResponses.with_preciptation()
        |> MyUmbrella.create_null()
        |> MyUmbrella.for_today(london, current_date_time)

      expected_weather =
        current_date_time
        |> CurrentDateTimeControl.before_midnight()
        |> WeatherControl.Rain.example()

      assert {:ok, {:precipitation, actual_weather}} = weather_result
      assert Weather.eq?(actual_weather, expected_weather)
    end

    test "given it IS NOT raining before end-of-day; then an umbrella IS NOT needed" do
      orlando = CoordinatesControl.example(:orlando)
      current_date_time = CurrentDateTimeControl.Utc.example(:orlando)

      weather_result =
        MyUmbrella.NullResponses.new()
        |> MyUmbrella.NullResponses.no_preciptation()
        |> MyUmbrella.create_null()
        |> MyUmbrella.for_today(orlando, current_date_time)

      assert {:ok, :no_precipitation} == weather_result
    end
  end
end
