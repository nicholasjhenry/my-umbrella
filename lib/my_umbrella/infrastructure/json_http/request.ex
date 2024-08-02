defmodule MyUmbrella.Infrastructure.JsonHttp.Request do
  @moduledoc """
  A network communication with a method and URL endpoint. For example:
  a `GET` method to retrieve data from `/api/users` endpoint.
  """

  alias __MODULE__, as: JsonRequest

  @type headers() :: [{String.t(), String.t()}]

  @type t() :: %JsonRequest{
          url: String.t(),
          headers: headers(),
          body: map()
        }

  @enforce_keys [:url]
  defstruct [:url, method: :get, headers: [{"Content-Type", "application/json"}], body: %{}]

  @spec new(keyword()) :: t()
  def new(attrs) do
    attrs = Keyword.validate!(attrs, [:url, :method, :headers, :body])
    struct!(__MODULE__, attrs)
  end
end
