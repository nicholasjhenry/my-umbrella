defmodule MyUmbrella.Infrastructure.JsonHttp.Response do
  @moduledoc """
  A communication response with a specific status code and body content. For example:
  a `404` status code with a `Not Found` message in the body.
  """

  alias __MODULE__, as: JsonResponse

  @type t() :: t(map())
  @type t(body) :: %JsonResponse{
          status_code: integer(),
          body: body,
          headers: list()
        }

  @enforce_keys [:status_code, :body]
  defstruct [
    :status_code,
    body: %{},
    headers: [{"Content-Type", "application/json; charset=utf-8"}]
  ]

  @spec new(Enumerable.t()) :: t()
  def new(attrs) do
    attrs = Keyword.validate!(attrs, [:status_code, :body, :headers])
    struct!(__MODULE__, attrs)
  end
end
