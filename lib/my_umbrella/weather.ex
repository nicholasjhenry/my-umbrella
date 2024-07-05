defmodule MyUmbrella.Weather do
  @moduledoc """
  A type representing the weather reported.
  """
  defstruct [:datetime, :code]

  @type t :: %__MODULE__{
          datetime: DateTime.t(),
          code: integer()
        }
end
