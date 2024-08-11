defmodule Examples.MixShellTest do
  use ExUnit.Case, async: true

  setup do
    Mix.shell(Mix.Shell.Process)

    on_exit(fn -> Mix.shell(Mix.Shell.IO) end)
  end

  test "output tracking" do
    Mix.shell().info("hello")

    assert_receive {:mix_shell, :info, [msg]}
    assert msg == "hello"
  end
end
