defmodule Servy.PledgeServer do

  @process_name :pledge_server

  alias Servy.GenericServer


  # Client Interface
  def start do
    GenericServer.start(__MODULE__, [], @process_name)
  end

  def kill do
    Process.exit(Process.whereis(@process_name), :kill)
  end

  def create_pledge(name, amount) do
    GenericServer.call @process_name, {:create_pledge, name, amount}
  end

  def recent_pledges() do
    GenericServer.call @process_name, :recent_pledges
  end

  def clear do
    GenericServer.cast @process_name, :clear
  end

  # Server callbacks
  def handle_call(:recent_pledges, state) do
    { state, state }
  end

  def handle_call({:create_pledge, name, amount}, state) do
    response = send_pledge_to_service(name, amount)
    new_state = [ %{ name: name, amount: amount } | state] |> Enum.take(3)
    { response, new_state }
  end

  def handle_cast(:clear, _state) do
    []
  end

  def send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(10_000)}"}
  end
end
