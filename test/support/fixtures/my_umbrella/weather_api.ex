defmodule MyUmbrella.Fixtures.WeatherApi do
  @moduledoc false

  def response_fixture(:precipitation, {lat, lon}, time_zone) do
    response = %{
      "lat" => lat,
      "lon" => lon,
      "timezone" => time_zone,
      "current" => %{
        "dt" => 946_762_200,
        "weather" => [
          %{
            "id" => 802,
            "main" => "Clouds",
            "description" => "scattered clouds"
          }
        ]
      },
      "hourly" => [
        %{
          "dt" => 946_764_000,
          "weather" => [
            %{
              "id" => 501,
              "main" => "Rain",
              "description" => "moderate rain"
            }
          ]
        }
      ]
    }

    {:ok, response}
  end

  def response_fixture(:no_precipitation, {lat, lon}, time_zone) do
    response = %{
      "lat" => lat,
      "lon" => lon,
      "timezone" => time_zone,
      "current" => %{
        "dt" => 946_762_200,
        "weather" => [
          %{
            "id" => 803,
            "main" => "Clouds",
            "description" => "broken clouds"
          }
        ]
      },
      "hourly" => [
        %{
          "dt" => 946_764_000,
          "weather" => [
            %{
              "id" => 803,
              "main" => "Clouds",
              "description" => "broken clouds"
            }
          ]
        }
      ]
    }

    {:ok, response}
  end

  def response_fixture(:error, _coordinates, _time_zone) do
    not_authorized = {:status, 401}

    {:error, not_authorized}
  end
end
