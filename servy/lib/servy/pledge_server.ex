defmodule Servy.PledgeServer do

  @process_name :pledge_server

  def start do
    pid = spawn(__MODULE__, :listen_loop, [[]])
    Process.register(pid, @process_name)
    pid
  end

  def kill do
    Process.exit(Process.whereis(@process_name), :kill)
  end

  def listen_loop(state) do
    receive do
      { caller, :create_pledge, name, amount } ->
        {:ok, id} = send_pledge_to_service(name, amount)
        new_state = [ %{ name: name, amount: amount } | state] |> Enum.take(3)
        send(caller, {:ok, id})
        listen_loop(new_state)

      { caller, :recent_pledges } ->
        send(caller, {:ok, pledges: state})
        listen_loop(state)
    end
  end

  def create_pledge(name, amount) do
    send(@process_name, {self(), :create_pledge, name, amount})

    receive do {:ok, id} -> id end
  end

  def recent_pledges() do
    send(@process_name, {self(), :recent_pledges})

    receive do
      {:ok, pledges: pledges} -> pledges
    end

  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(10_000)}"}
  end
end
