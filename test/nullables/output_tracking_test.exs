defmodule Nullables.OutputTrackingTest do
  use ExUnit.Case, async: true

  alias Nullables.OutputTracking

  test "tracking output", %{test: test} do
    ref = OutputTracking.track_output(test, [:output_tracking, :foo])
    :ok = OutputTracking.emit([:output_tracking, :foo], %{bar: :qux})

    assert_received {[:output_tracking, :foo], ^ref, %{bar: :qux}}
  end
end
