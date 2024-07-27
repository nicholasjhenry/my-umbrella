defmodule MyUmbrella.TestCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      import MyUmbrella.TestCase
    end
  end

  setup _context do
    project_path = Mix.Project.project_file() |> Path.dirname()
    fixture_path = Path.join([project_path, "test/fixtures"])

    %{fixture_path: fixture_path}
  end
end
