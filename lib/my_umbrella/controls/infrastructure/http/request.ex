defmodule MyUmbrella.Controls.Infrastructure.Http.Request do
  @moduledoc false

  alias MyUmbrella.Infrastructure.Http.Request

  defmodule Get do
    @moduledoc false

    @spec example() :: Request.t()
    def example do
      Request.new(
        url: "http://NOT_CONNECTED/get",
        headers: [{"Content-Type", "application/json"}]
      )
    end
  end
end
