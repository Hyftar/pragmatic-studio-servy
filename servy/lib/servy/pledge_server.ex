defmodule Servy.PledgeServer do

  @process_name :pledge_server

  use GenServer

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  # Client Interface
  def start do
    GenServer.start(__MODULE__, %State{}, name: @process_name)
  end

  def kill do
    Process.exit(Process.whereis(@process_name), :kill)
  end

  def create_pledge(name, amount) do
    GenServer.call @process_name, {:create_pledge, name, amount}
  end

  def recent_pledges() do
    GenServer.call @process_name, :recent_pledges
  end

  def set_cache_size(size) do
    GenServer.cast @process_name, {:set_cache_size, size}
  end

  def clear do
    GenServer.cast @process_name, :clear
  end

  # Server callbacks
  def init(state) do
    {:ok, state}
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state.pledges, state}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    response = send_pledge_to_service(name, amount)
    cached_pledges =
      [ %{ name: name, amount: amount } | state.pledges]
      |> Enum.take(state.cache_size)

    new_state = %{ state | pledges: cached_pledges }

    {:reply, response, new_state}
  end

  def handle_cast({:set_cache_size, size}, state) do
    new_state = %{ state | cache_size: size }

    {:noreply, new_state}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{state | pledges: []}}
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(10_000)}"}
  end
end
