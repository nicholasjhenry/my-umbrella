defmodule Nullables.ConfigurableResponsesTest do
  use ExUnit.Case, async: true

  alias Nullables.ConfigurableResponses

  test "returns the value for a key" do
    responses = [{:ping, :pong}, {:ping, :bar}]
    {:ok, _pid} = ConfigurableResponses.start_link(__MODULE__, responses)

    response = ConfigurableResponses.get_response(__MODULE__, :ping)
    assert response == :pong

    task = Task.async(fn -> ConfigurableResponses.get_response(__MODULE__, :ping) end)
    response = Task.await(task)
    assert response == :bar
  end
end
