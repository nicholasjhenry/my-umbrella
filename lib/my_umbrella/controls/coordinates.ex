defmodule MyUmbrella.Controls.Coordinates do
  @moduledoc false

  alias MyUmbrella.Coordinates

  @spec example(:london | :orlando) :: Coordinates.t()
  def example(:london) do
    Coordinates.new(51.5098, -0.118)
  end

  def example(:orlando) do
    Coordinates.new(28.5383, -81.3792)
  end
end
