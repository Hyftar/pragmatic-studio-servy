defmodule Servy.FourOhFourCounter do
  alias Servy.GenericServer

  @process_name :four_oh_four_counter

  # Client Interface
  def start() do
    GenericServer.start(__MODULE__, %{}, @process_name)
  end

  def kill() do
    Process.exit(Process.whereis(@process_name), :kill)
  end

  def bump(path) do
    GenericServer.call @process_name, {:bump, path}
  end

  def get_count(path) do
    GenericServer.call @process_name, {:get_count, path}
  end

  # Server callbacks
  def handle_call({:bump, path}, state) do
    new_state = Map.update(state, path, 1, &(&1 + 1))
    { :ok, new_state }
  end

  def handle_call({:get_count, path}, state) do
    count = Map.get(state, path, 0)
    { count, state }
  end
end
