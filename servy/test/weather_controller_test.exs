defmodule WeatherControllerTest do
  use ExUnit.Case

  alias Servy.HttpServer

  setup do
    pid = spawn(HttpServer, :start, [4000])

    on_exit(fn ->
      Servy.PledgeServer.kill()
      Servy.FourOhFourCounter.kill()
      Servy.WeatherServer.kill()
      Process.exit(pid, :kill)
    end)

    :ok
  end

  test "should get weather data" do
    {:ok, response} = HTTPoison.get "http://localhost:4000/api/weather"

    assert response.status_code == 200
  end

  test "should get different weather data after refresh" do
    {:ok, response} = HTTPoison.get "http://localhost:4000/api/weather"

    :timer.sleep(:timer.seconds(6))

    {:ok, response2} = HTTPoison.get "http://localhost:4000/api/weather"

    assert response.body != response2.body
  end
end
