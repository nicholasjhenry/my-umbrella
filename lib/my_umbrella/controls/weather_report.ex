defmodule MyUmbrella.Controls.WeatherReport do
  @moduledoc false

  alias MyUmbrella.WeatherReport

  alias MyUmbrella.Controls.Calendar.CurrentDateTime, as: CurrentDateTimeControl
  alias MyUmbrella.Controls.Coordinates, as: CoordinatesControl

  def attributes(location \\ :london, time_zone \\ nil) do
    coordinates = CoordinatesControl.example(location)
    timezone = time_zone || CurrentDateTimeControl.LocalTime.example(location).time_zone

    %{coordinates: coordinates, time_zone: timezone}
  end

  @spec example(:london | :orlando, String.t() | nil) :: WeatherReport.t()
  def example(location \\ :london, time_zone \\ nil) do
    attributes(location, time_zone) |> WeatherReport.new()
  end
end
