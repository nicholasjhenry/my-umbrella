defmodule MyUmbrellaWeb.Router do
  @moduledoc """
  A simple router.
  """

  alias MyUmbrellaWeb.Controller

  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    conn
    |> fetch_query_params(opts)
    |> route
  end

  defp route(conn) do
    case conn.request_path do
      "/" ->
        Controller.show(conn, conn.query_params)

      _ ->
        page_not_found(conn)
    end
  end

  defp page_not_found(conn) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(404, "Not found")
  end
end
