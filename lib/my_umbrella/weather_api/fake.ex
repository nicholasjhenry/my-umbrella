defmodule MyUmbrella.WeatherApi.Fake do
  @moduledoc false

  alias MyUmbrella.WeatherApi.Response

  @type coordinates :: {float(), float()}

  @orlando {28.5383, -81.3792}
  @london {51.5098, -0.118}

  @spec get_forecast(coordinates, duration :: :today) :: {:ok, Response.t()}
  def get_forecast(@london, :today) do
    project_path = Mix.Project.project_file() |> Path.dirname()
    fixture_path = Path.join([project_path, "test/fixtures"])
    fixture_pathname = Path.join([fixture_path, "response/success_london.json"])
    response = fixture_pathname |> File.read!() |> :json.decode()

    {:ok, response}
  end

  def get_forecast(@orlando, :today) do
    project_path = Mix.Project.project_file() |> Path.dirname()
    fixture_path = Path.join([project_path, "test/fixtures"])
    fixture_pathname = Path.join([fixture_path, "response/success_orlando.json"])
    response = fixture_pathname |> File.read!() |> :json.decode()

    {:ok, response}
  end
end
