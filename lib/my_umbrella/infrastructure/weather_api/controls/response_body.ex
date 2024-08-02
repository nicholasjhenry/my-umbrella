defmodule MyUmbrella.Infrastructure.WeatherApi.Controls.ResponseBody do
  @moduledoc false

  alias MyUmbrella.Infrastructure.WeatherApi.ResponseBody

  defmodule Success do
    @moduledoc false

    @control_path Application.app_dir(:my_umbrella, "priv/controls")
    @spec example(:london | :orlando) :: ResponseBody.t()
    def example(:london) do
      control_pathname =
        Path.join([@control_path, "weather_api/response_body/success_london.json"])

      control_pathname |> File.read!() |> :json.decode()
    end

    def example(:orlando) do
      control_pathname =
        Path.join([@control_path, "weather_api/response_body/success_orlando.json"])

      control_pathname |> File.read!() |> :json.decode()
    end
  end
end
