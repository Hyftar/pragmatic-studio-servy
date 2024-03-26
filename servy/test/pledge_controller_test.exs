defmodule PledgeControllerTest do
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

  test "retuns an empty pledge list" do
    {:ok, response} = HTTPoison.get "http://localhost:4000/pledges"

    assert response.status_code == 200
    assert response.body == "{\"pledges\":[]}"
  end

  test "adds a new pledge and recent pledges contains it" do
    HTTPoison.post!("http://localhost:4000/pledges", "name=larry&amount=10", "Content-Type": "application/x-www-form-urlencoded")

    {:ok, response} = HTTPoison.get "http://localhost:4000/pledges"

    assert response.status_code == 200
    assert response.body == "{\"pledges\":[{\"amount\":10,\"name\":\"larry\"}]}"

    HTTPoison.post!("http://localhost:4000/pledges", "name=barry&amount=15", "Content-Type": "application/x-www-form-urlencoded")

    {:ok, response} = HTTPoison.get "http://localhost:4000/pledges"

    assert response.status_code == 200
    assert response.body == "{\"pledges\":[{\"amount\":15,\"name\":\"barry\"},{\"amount\":10,\"name\":\"larry\"}]}"
  end
end
