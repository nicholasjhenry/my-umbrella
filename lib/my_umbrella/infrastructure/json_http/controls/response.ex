defmodule MyUmbrella.Infrastructure.JsonHttp.Controls.Response do
  @moduledoc false

  alias MyUmbrella.Infrastructure.JsonHttp.Response

  @spec example() :: Response.t()
  def example do
    Response.new(
      status_code: 200,
      body: %{"hello" => "world"}
    )
  end

  defmodule NotImplemented do
    @moduledoc false

    @spec example() :: Response.t()
    def example do
      Response.new(
        status_code: 503,
        body: %{"error" => "Not implemented"}
      )
    end
  end
end
