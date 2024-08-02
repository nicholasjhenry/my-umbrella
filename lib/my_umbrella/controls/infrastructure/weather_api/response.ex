defmodule MyUmbrella.Controls.Infrastructure.WeatherApi.Response do
  @moduledoc false

  alias MyUmbrella.Infrastructure.JsonHttp
  alias MyUmbrella.Controls.Infrastructure.WeatherApi

  defmodule Success do
    @spec example(:london | :orlando) :: JsonResponse.t()
    def example(location) do
      body = WeatherApi.ResponseBody.Success.example(location)

      JsonHttp.Response.new(
        status_code: 200,
        body: body
      )
    end
  end

  defmodule Error do
    @moduledoc false

    @spec example() :: Response.t()
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
