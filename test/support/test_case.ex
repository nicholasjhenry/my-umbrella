defmodule MyUmbrella.TestCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      import MyUmbrella.TestCase
    end
  end

  setup _context do
    control_path = Application.app_dir(:my_umbrella, "priv/controls/")

    %{control_path: control_path}
  end
end
