defmodule Servy.KickStarter do
  use GenServer

  def start do
    IO.puts "🐎  Starting the kickstarter..."

    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.flag(:trap_exit, true)

    start_http_server()
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts "⚠️  HTTP server exited with reason: #{inspect reason}"

    {:ok, server_pid} = start_http_server()

    {:noreply, server_pid}
  end

  def start_http_server do
    IO.puts "🚀  Starting the HTTP server..."

    server_pid = spawn_link(Servy.HttpServer, :start, [4000])

    Process.register(server_pid, :http_server)

    {:ok, server_pid}
  end
end
