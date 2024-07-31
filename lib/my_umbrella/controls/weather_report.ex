defmodule MyUmbrella.Controls.WeatherReport do
  @moduledoc false

  alias MyUmbrella.WeatherReport

  alias MyUmbrella.Controls.Coordinates, as: CoordinatesControl
  alias MyUmbrella.Controls.Calendar.CurrentDateTime, as: CurrentDateTimeControl

  def attributes(location \\ :london, time_zone \\ nil) do
    coordinates = CoordinatesControl.example(location)
    timezone = time_zone || CurrentDateTimeControl.LocalTime.example(location).time_zone

    %{coordinates: coordinates, time_zone: timezone}
  end

  @spec example(:london | :orlando, String.t()) :: WeatherReport.t()
  def example(location \\ :london, time_zone \\ nil) do
    attributes(location, time_zone) |> WeatherReport.new()
  end
end
