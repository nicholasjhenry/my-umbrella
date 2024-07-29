defmodule MyUmbrellaWeb.Server do
  @moduledoc """
  An HTTP server to host the `MyUmbrellaWeb.Controller` plug.
  """
  require Logger

  def start do
    webserver =
      {Plug.Cowboy, plug: MyUmbrellaWeb.Router, scheme: :http, options: [port: 4000]}

    {:ok, _} = Supervisor.start_link([webserver], strategy: :one_for_one)

    Logger.info("Plug now running on localhost:4000")
    Process.sleep(:infinity)
  end
end
