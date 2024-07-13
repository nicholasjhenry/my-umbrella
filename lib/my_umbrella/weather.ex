defmodule MyUmbrella.Weather do
  @moduledoc """
  A type representing the weather reported or forecasted.
  """
  alias MyUmbrella.Coordinates

  defstruct [:coordinates, :datetime, :code]

  @type t :: %__MODULE__{
          coordinates: Coordinates.t(),
          datetime: DateTime.t(),
          code: integer()
        }

  @spec eq?(t(), t()) :: boolean()
  def eq?(lhs, rhs) do
    lhs.coordinates == rhs.coordinates &&
      DateTime.compare(lhs.datetime, rhs.datetime) == :eq &&
      lhs.code == rhs.code
  end
end
