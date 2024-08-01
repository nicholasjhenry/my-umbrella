defmodule MyUmbrella.Controls.Infrastructure.Http.Response do
  @moduledoc false

  alias MyUmbrella.Infrastructure.Http.Response

  @spec example() :: Response.t()
  def example do
    Response.new(
      status_code: 200,
      headers: [{"Content-Type", "application/json; charset=utf-8"}],
      body: %{"hello" => "world"}
    )
  end

  defmodule NotImplemented do
    @moduledoc false

    @spec example() :: Response.t()
    def example do
      Response.new(
        status_code: 503,
        headers: [{"Content-Type", "application/json; charset=utf-8"}],
        body: %{"error" => "Not implemented"}
      )
    end
  end
end
