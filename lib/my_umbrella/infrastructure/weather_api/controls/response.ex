defmodule MyUmbrella.Infrastructure.WeatherApi.Controls.Response do
  @moduledoc false

  alias MyUmbrella.Infrastructure.JsonHttp
  alias MyUmbrella.Infrastructure.WeatherApi

  alias MyUmbrella.Infrastructure.WeatherApi.Controls, as: WeatherApiControls

  defmodule Success do
    @moduledoc false

    @spec example(:london | :orlando) :: WeatherApi.Response.t()
    def example(location) do
      body = WeatherApiControls.ResponseBody.Success.example(location)

      JsonHttp.Response.new(
        status_code: 200,
        body: body
      )
    end
  end

  defmodule Error do
    @moduledoc false

    @spec example() :: WeatherApi.Response.t()
    def example do
      body = %{
        "cod" => 401,
        "message" =>
          "Please note that using One Call 3.0 requires a separate subscription to the One Call by Call plan. Learn more here https://openweathermap.org/price. If you have a valid subscription to the One Call by Call plan, but still receive this error, then please see https://openweathermap.org/faq#error401 for more info."
      }

      JsonHttp.Response.new(
        status_code: 401,
        body: body
      )
    end
  end
end
