defmodule MyUmbrella.Fixtures do
  @moduledoc false

  alias MyUmbrella.Coordinates

  def coordinates_fixture(:london) do
    Coordinates.new(51.5098, -0.118)
  end

  def coordinates_fixture(:orlando) do
    Coordinates.new(28.5383, -81.3792)
  end
end
