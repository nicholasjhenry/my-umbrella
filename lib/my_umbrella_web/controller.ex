defmodule MyUmbrellaWeb.Controller do
  @moduledoc """
  A simple controller to demonstrate nesting with an Infrastructure Wrapper.
  """

  import Plug.Conn

  def show(conn, %{"lat" => lat, "lon" => lon}) do
    coordinates = MyUmbrella.Coordinates.parse(lat, lon)
    current_date_time_utc = Map.get(conn.assigns, :current_date_time_utc, DateTime.utc_now())
    my_umbrella = Map.get(conn.assigns, :my_umbrella, MyUmbrella.create())

    {status_code, text} =
      case MyUmbrella.for_today(my_umbrella, coordinates, current_date_time_utc) do
        {:ok, :no_precipitation} -> {200, "No, not today!"}
        {:ok, {:precipitation, _weather}} -> {200, "Yes, definitey!"}
      end

    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(status_code, text)
  end
end
