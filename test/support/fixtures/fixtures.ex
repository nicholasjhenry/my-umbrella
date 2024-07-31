defmodule MyUmbrella.Fixtures do
  @moduledoc false

  alias MyUmbrella.Coordinates

  def coordinates_fixture(:london) do
    Coordinates.new(51.5098, -0.118)
  end

  def coordinates_fixture(:orlando) do
    Coordinates.new(28.5383, -81.3792)
  end

  def date_time_fixture(:london) do
    DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], "Etc/UTC")
  end

  def date_time_fixture(:orlando) do
    DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], "America/New_York")
  end
end
