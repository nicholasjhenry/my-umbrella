defmodule MyUmbrella.Infrastructure.Http.Request do
  @moduledoc """
  A network communication with a method and URL endpoint. For example:
  a `GET` method to retrieve data from `/api/users` endpoint.
  """

  alias __MODULE__, as: Request

  @type headers() :: [{String.t(), String.t()}]

  @type t() :: %Request{
          url: String.t(),
          headers: headers(),
          body: String.t()
        }

  @enforce_keys [:url, :headers]
  defstruct [:url, method: :get, headers: [], body: ""]

  @spec new(keyword()) :: t()
  def new(attrs) do
    attrs = Keyword.validate!(attrs, [:url, :method, :headers, :body])
    struct!(__MODULE__, attrs)
  end
end
