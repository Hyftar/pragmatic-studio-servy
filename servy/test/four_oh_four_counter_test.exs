defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer

  setup do
    pid = spawn(HttpServer, :start, [4000])

    on_exit(fn ->
      Servy.PledgeServer.kill()
      Servy.FourOhFourCounter.kill()
      Process.exit(pid, :kill)
    end)

    :ok
  end

  test "retuns an empty pledge list" do
    1..5
    |> Enum.each(fn _ -> HTTPoison.get "http://localhost:4000/blah" end)

    1..3
    |> Enum.each(fn _ -> HTTPoison.get "http://localhost:4000/bleh" end)

    assert Servy.FourOhFourCounter.get_count("/blah") == 5
    assert Servy.FourOhFourCounter.get_count("/bleh") == 3
  end
end
