defmodule MyUmbrella.Controls.WeatherApi do
  @moduledoc false

  alias MyUmbrella.WeatherApi.Response

  alias MyUmbrella.Controls.Coordinates, as: CoordinatesControl

  @type coordinates :: {float(), float()}

  @orlando CoordinatesControl.example(:orlando)
  @london CoordinatesControl.example(:london)

  @control_path Application.app_dir(:my_umbrella, "priv/controls")

  @spec get_forecast(coordinates, duration :: :today) :: {:ok, Response.t()}
  def get_forecast(@london, :today) do
    control_pathname = Path.join([@control_path, "weather_api/response/success_london.json"])
    response = control_pathname |> File.read!() |> :json.decode()

    {:ok, response}
  end

  def get_forecast(@orlando, :today) do
    control_pathname = Path.join([@control_path, "weather_api/response/success_orlando.json"])
    response = control_pathname |> File.read!() |> :json.decode()

    {:ok, response}
  end
end
