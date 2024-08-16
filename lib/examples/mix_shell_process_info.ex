defmodule Examples.Mix.Shell.Process do
  @moduledoc """
  Example code for `Mix.Shell.Process`.
  """

  def info(message) do
    send(message_target(), {:mix_shell, :info, [message]})
    :ok
  end

  defp message_target do
    case Process.get(:"$callers") do
      [parent | _] -> parent
      _ -> self()
    end
  end
end
