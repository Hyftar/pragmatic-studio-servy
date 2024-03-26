defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer

  setup_all do
    spawn(HttpServer, :start, [4000])
    :ok
  end

  test "accepts a request on a socket and sends back a response" do
    {:ok, response} = HTTPoison.get "http://localhost:4000/wildthings"

    assert response.status_code == 200
    assert response.body == "Bears, Lions, Tigers"
  end

  test "sends multiple requests concurrently and handles all responses" do
    base_url = "http://localhost:4000/"

    urls = [
      "wildthings",
      "bears",
      "bears/1",
      "wildlife",
      "api/bears",
    ]

    urls
    |> Enum.map(fn url -> Task.async(fn -> HTTPoison.get(base_url <> url) end) end)
    |> Enum.map(&Task.await(&1))
    |> Enum.each(fn {:ok, response} -> assert response.status_code == 200 end)
  end
end
