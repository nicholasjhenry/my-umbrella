defmodule MyUmbrella.Infrastructure.JsonHttp.ClientTest do
  use MyUmbrella.TestCase, async: true

  alias MyUmbrella.Infrastructure.JsonHttp
  alias MyUmbrella.Infrastructure.JsonHttp.Controls, as: JsonHttpControls

  alias Nullables.OutputTracking

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  test "handling a GET request", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/get", fn conn ->
      assert conn.query_params == %{"foo" => "bar", "baz" => "qux"}
      assert conn.request_path == "/get"
      assert conn.method == "GET"

      body = Jason.encode!(%{"data" => %{"body" => "test"}})

      conn
      |> Plug.Conn.put_resp_header("Content-Type", "application/json; charset=utf-8")
      |> Plug.Conn.resp(200, body)
    end)

    http_client = JsonHttp.Client.create()

    result =
      JsonHttp.Client.get(http_client, "http://localhost:#{bypass.port}/get?foo=bar&baz=qux")

    assert {:ok, actual_response} = result
    assert actual_response.status_code == 200
    assert {"Content-Type", "application/json; charset=utf-8"} in actual_response.headers
    assert %{"data" => %{"body" => "test"}} == actual_response.body
  end

  describe "nullability" do
    test "default response", %{test: test} do
      http_client = JsonHttp.Client.create_null()
      ref = OutputTracking.track_output(test, [:http_client, :requests])

      result = JsonHttp.Client.get(http_client, "http://NOT_CONNECTED/get")

      expected_response = JsonHttpControls.Response.NotImplemented.example()

      assert_received {[:http_client, :requests], ^ref,
                       %JsonHttp.Request{url: "http://NOT_CONNECTED/get"}}

      assert {:ok, actual_response} = result
      assert actual_response.status_code == expected_response.status_code
      assert {"Content-Type", "application/json; charset=utf-8"} in actual_response.headers
      assert expected_response.body == actual_response.body
    end

    test "configurable response" do
      url = "http://NOT_CONNECTED/get"

      responses = [
        {url, JsonHttp.Controls.Response.example()}
      ]

      http_client = JsonHttp.Client.create_null(responses)

      result = JsonHttp.Client.get(http_client, url)

      assert {:ok, actual_response} = result
      assert actual_response.status_code == 200
      assert {"Content-Type", "application/json; charset=utf-8"} in actual_response.headers
      assert %{"hello" => "world"} == actual_response.body
    end
  end
end
