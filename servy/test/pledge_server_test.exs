defmodule PledgeServerTest do
  use ExUnit.Case

  setup_all do
    Servy.PledgeServer.start()
    :ok
  end

  test "Should accept pledges" do
    [
      Servy.PledgeServer.create_pledge("Larry", 10),
      Servy.PledgeServer.create_pledge("Curly", 20),
      Servy.PledgeServer.create_pledge("Moe", 30),
    ]
    |> Enum.each(fn result -> assert String.match?(result, ~r/^pledge-\d+$/) end)
  end

  test "Should return recent pledges" do
    Servy.PledgeServer.create_pledge("Larry", 10)
    Servy.PledgeServer.create_pledge("Curly", 20)
    Servy.PledgeServer.create_pledge("Moe", 30)
    Servy.PledgeServer.create_pledge("Joe", 40)
    Servy.PledgeServer.create_pledge("Mike", 50)

    recent_pledgers =
      Servy.PledgeServer.recent_pledges()

    assert recent_pledgers == [{"Mike", 50}, {"Joe", 40}, {"Moe", 30}]
  end
end
