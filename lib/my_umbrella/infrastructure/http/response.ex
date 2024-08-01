defmodule MyUmbrella.Infrastructure.Http.Response do
  @moduledoc """
  A communication response with a specific status code and body content. For example:
  a `404` status code with a `Not Found` message in the body.
  """

  alias __MODULE__, as: Response

  @type t() :: %Response{
          status_code: integer(),
          body: String.t(),
          headers: list()
        }

  @enforce_keys [:status_code, :body, :headers]
  defstruct [:status_code, body: "", headers: []]

  @spec new(Enumerable.t()) :: t()
  def new(attrs) do
    attrs = Keyword.validate!(attrs, [:status_code, :body, :headers])
    struct!(__MODULE__, attrs)
  end
end
