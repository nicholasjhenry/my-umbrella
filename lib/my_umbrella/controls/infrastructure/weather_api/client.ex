defmodule MyUmbrella.Controls.Infrastructure.WeatherApi.Client do
  @moduledoc false

  alias MyUmbrella.Coordinates

  alias MyUmbrella.Infrastructure.WeatherApi.Response

  alias MyUmbrella.Controls.Coordinates, as: CoordinatesControl

  @orlando CoordinatesControl.example(:orlando)
  @london CoordinatesControl.example(:london)

  @control_path Application.app_dir(:my_umbrella, "priv/controls")

  @spec get_forecast(Coordinates.t(), duration :: :today) :: {:ok, Response.t()}
  def get_forecast(@london, :today) do
    control_pathname = Path.join([@control_path, "weather_api/response/success_london.json"])
    body = control_pathname |> File.read!() |> :json.decode()

    {:ok, Response.new(body)}
  end

  def get_forecast(@orlando, :today) do
    control_pathname = Path.join([@control_path, "weather_api/response/success_orlando.json"])
    body = control_pathname |> File.read!() |> :json.decode()

    {:ok, Response.new(body)}
  end
end
