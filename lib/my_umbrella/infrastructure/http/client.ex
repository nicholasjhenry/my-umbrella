defmodule MyUmbrella.Infrastructure.Http.Client do
  @moduledoc """
  A nullable low-level infrastructure wrapper for the HTTP protocol.

  ## Infrastructure Wrappers

  > Infrastructure code is complicated to write, hard to test, and often difficult to understand.
  >
  > Therefore:
  >
  > Isolate your Infrastructure code. For each external system—service, database, file system, or
  > even environment variables—create one wrapper class that’s solely responsible for interfacing
  > with that system. Design your wrappers to provide a crisp, clean view of the messy outside world,
  > in whatever format is most useful to the rest of your code.

  -- https://www.jamesshore.com/v2/projects/nullables/testing-without-mocks#infrastructure-wrappers

  ## Nullables

  > Narrow Integration Tests are slow and difficult to set up. Although they’re useful for ensuring that low-level
  > Infrastructure Wrappers work in practice, they’re overkill for code that depends on those wrappers.
  >
  > Therefore:
  >
  > Program code that includes infrastructure in its dependency chain to have a createNull() factory method.
  > The factory should create a “Nulled” instance that disables all external communication, but behaves
  > normally in every other respect.

  -- https://www.jamesshore.com/v2/projects/nullables/testing-without-mocks#nullables
  """

  alias MyUmbrella.Infrastructure.Http

  alias MyUmbrella.Controls.Infrastructure.Http, as: HttpControls

  alias Nullables.ConfigurableResponses
  alias Nullables.OutputTracking

  @type t() :: %Http.Client{
          httpoison: HTTPoison | Http.Client.StubbedHTTPoison
        }

  @enforce_keys [:httpoison]
  defstruct [:httpoison]

  defmodule StubbedHTTPoison do
    @moduledoc """
    > Nullables need to disable access to external systems and state while running everything else normally.
    > The obvious approach is to surround any code that accesses the external system with an “if” statement,
    > but that’s a recipe for spaghetti.
    >
    > Therefore:
    >
    > When making code Nullable, don’t change your code. Instead, stub out the third-party code that
    > accesses external systems.

    -- https://www.jamesshore.com/v2/projects/nullables/testing-without-mocks#embedded-stub
    """
    @spec get(String.t(), HTTPoison.headers()) :: {:ok, HTTPoison.Response.t()}
    def get(url, _headers) do
      response = url |> get_response |> to_httpoison

      {:ok, response}
    end

    defp get_response(url) do
      ConfigurableResponses.get_response(
        StubbedHTTPoison,
        url,
        HttpControls.Response.NotImplemented.example()
      )
    end

    defp to_httpoison(response) when is_struct(response) do
      attrs = %{
        status_code: response.status_code,
        headers: response.headers,
        body: Jason.encode!(response.body)
      }

      struct!(HTTPoison.Response, attrs)
    end
  end

  @spec create() :: t()
  def create do
    %Http.Client{httpoison: HTTPoison}
  end

  @spec create_null(ConfigurableResponses.responses()) :: t()
  def create_null(responses \\ []) do
    {:ok, _pid} = ConfigurableResponses.start_link(StubbedHTTPoison, responses)
    %Http.Client{httpoison: StubbedHTTPoison}
  end

  @spec get(t(), String.t()) :: {:ok, Http.Response.t()}
  def get(client, url) do
    headers = [{"Content-Type", "application/json"}]
    request = Http.Request.new(url: url, headers: headers)

    {:ok, httpoison_response} = client.httpoison.get(request.url, request.headers)

    :ok = OutputTracking.emit([:http_client, :requests], request)

    response =
      Http.Response.new(
        status_code: httpoison_response.status_code,
        headers: httpoison_response.headers,
        body: Jason.decode!(httpoison_response.body)
      )

    {:ok, response}
  end
end
