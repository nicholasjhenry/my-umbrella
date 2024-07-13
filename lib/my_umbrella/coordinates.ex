defmodule MyUmbrella.Coordinates do
  @moduledoc """
  Coordinate system that specifies a point on Earth's surface using angular measurements.
  """

  @type t :: {float(), float()}

  @spec new(float(), float()) :: t
  def new(latitude, longitude) do
    {latitude, longitude}
  end
end
