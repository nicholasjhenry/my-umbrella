defmodule MyUmbrella.Weather do
  @moduledoc """
  A form of communication for forecasting atmospheric conditions, precipitation, and
  wind patterns, for specific coordinates and time.
  """

  @enforce_keys [:date_time, :condition, :code]

  defstruct [:date_time, :condition, :code]

  @type condition :: :atmosphere | :clear | :clouds | :drizzle | :rain | :snow | :thunderstorm

  @type t :: %__MODULE__{
          date_time: DateTime.t(),
          condition: condition(),
          code: integer()
        }

  @spec new(Enumerable.t()) :: t()
  def new(attrs) do
    struct!(__MODULE__, attrs)
  end

  @spec eq?(t(), t()) :: boolean()
  def eq?(lhs, rhs) do
    DateTime.compare(lhs.date_time, rhs.date_time) == :eq &&
      lhs.condition == rhs.condition &&
      lhs.code == rhs.code
  end
end
