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
    |> Enum.map(fn {:ok, result} -> result end)
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

    assert recent_pledgers == [
      %{name: "Mike", amount: 50},
      %{name: "Joe", amount: 40},
      %{name: "Moe", amount: 30},
    ]
  end

  test "Should set cache size" do
    Servy.PledgeServer.set_cache_size(2)
    Servy.PledgeServer.create_pledge("Larry", 10)
    Servy.PledgeServer.create_pledge("Curly", 20)
    Servy.PledgeServer.create_pledge("Moe", 30)

    assert Servy.PledgeServer.recent_pledges() == [
      %{name: "Moe", amount: 30},
      %{name: "Curly", amount: 20},
    ]

    Servy.PledgeServer.set_cache_size(5)
    Servy.PledgeServer.create_pledge("Larry", 40)
    Servy.PledgeServer.create_pledge("Barry", 50)
    Servy.PledgeServer.create_pledge("Mary", 60)

    assert Servy.PledgeServer.recent_pledges() == [
      %{name: "Mary", amount: 60},
      %{name: "Barry", amount: 50},
      %{name: "Larry", amount: 40},
      %{name: "Moe", amount: 30},
      %{name: "Curly", amount: 20},
    ]
  end
end
