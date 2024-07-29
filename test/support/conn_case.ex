defmodule MyUmbrella.ConnCase do
  @moduledoc false

  use ExUnit.CaseTemplate
  use Plug.Test

  using do
    quote do
      import MyUmbrella.ConnCase
    end
  end

  setup _context do
    conn =
      conn("get", "/", "")
      |> put_req_header("content-type", "text/plain")

    %{conn: conn}
  end
end
