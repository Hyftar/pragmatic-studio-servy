defmodule Servy.GenericServer do
  def start(callback_module, initial_state, name) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state, callback_module])
    Process.register(pid, name)
    pid
  end

  def listen_loop(state, callback_module) do
    receive do
      {:call, caller, message} when is_pid(caller) ->
        {response, new_state} = callback_module.handle_call(message, state)
        send(caller, {:ok, response})
        listen_loop(new_state, callback_module)
      {:cast, message} ->
        new_state = callback_module.handle_cast(message, state)
        listen_loop(new_state, callback_module)
      unexpected ->
        IO.puts("Unexpected message: #{inspect unexpected}")
        listen_loop(state, callback_module)
    end
  end

  def call(pid, message) do
    send(pid, {:call, self(), message})

    receive do {:ok, response} -> response end
  end

  def cast(pid, message) do
    send(pid, {:cast, message})
  end
end
