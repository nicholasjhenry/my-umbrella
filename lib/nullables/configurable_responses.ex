defmodule Nullables.ConfigurableResponses do
  @moduledoc """
  > State-based tests of code with infrastructure dependencies needs to set up the infrastructure’s
  > state, but setting up external systems is complicated and slow.
  >
  > Therefore:
  >
  > Make the infrastructure dependencies Nullable and program the createNull() factory to take your
  > desired response as an optional parameter. Define the responses from the perspective of the
  > dependency’s externally-visible behavior, not its implementation.
  >

  -- https://www.jamesshore.com/v2/projects/nullables/testing-without-mocks#configurable-responses
  """
  use Agent

  @type responses() :: list({term(), term()})

  @spec start_link(module(), responses()) :: Agent.on_start()
  def start_link(module, responses \\ []) do
    Agent.start_link(fn -> responses end, name: {:global, {self(), module}})
  end

  @spec get_response(module(), term(), term()) :: term()
  def get_response(module, key, default \\ nil) do
    agent = {:global, {parent_pid(), module}}

    Agent.get_and_update(agent, &pop_response(&1, key)) || default
  end

  defp pop_response(responses, key) do
    case Enum.find_index(responses, fn {k, _v} -> k == key end) do
      index when is_integer(index) ->
        {{_key, value}, new_responses} = List.pop_at(responses, index)
        {value, new_responses}

      nil ->
        {nil, responses}
    end
  end

  defp parent_pid do
    case Process.get(:"$callers") do
      [parent_id | _] -> parent_id
      nil -> self()
    end
  end
end
