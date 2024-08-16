defmodule Nullables.OutputTracking do
  @moduledoc """
  > State-based tests of code with dependencies that write to external systems need to check
  > whether the writes were performed, but setting up external systems is complicated and slow.
  >
  > Therefore:
  >
  > Program each dependency with a tested, production-grade trackXxx() method that tracks the
  > otherwise-invisible writes. Have it do so regardless of whether the object is Nulled or not.

  -- https://www.jamesshore.com/v2/projects/nullables/testing-without-mocks#output-tracking
  """

  @spec track_output(:telemetry.handler_id(), :telemetry.event_name()) :: reference()
  def track_output(handler_id, event_name) do
    ref = make_ref()
    config = %{caller_pid: self(), ref: ref}

    :ok = :telemetry.attach(handler_id, event_name, &__MODULE__.handle_event/4, config)

    ref
  end

  def handle_event(event_name, _measurements, data, config) do
    [module, function | _] = event_name

    send(config.caller_pid, {[module, function], config.ref, data})
  end

  @spec emit(:telemetry.event_name(), term()) :: :ok
  def emit(event_name, data) do
    :telemetry.execute(event_name, %{}, data)
  end
end
