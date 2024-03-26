defmodule Servy.WeatherServer do
  @process_name :sensor_server
  @refresh_interval :timer.seconds(5)

  use GenServer

  def start do
    GenServer.start(__MODULE__, %{ weather: %{}}, name: @process_name)
  end

  def kill do
    Process.exit(Process.whereis(@process_name), :kill)
  end

  def get_weather_data() do
    GenServer.call @process_name, {:get_weather_data}
  end

  def get_weather_data(location) do
    GenServer.call @process_name, {:get_weather_data, location}
  end

  def init(state) do
    weather = get_weather_update()

    schedule_refresh()

    {:ok, Map.merge(state, weather)}
  end

  def handle_call({:get_weather_data, location}, _from, state) do
    {:reply, state.weather[location], state}
  end

  def handle_call({:get_weather_data}, _from, state) do
    {:reply, state.weather, state}
  end

  def handle_info(:refresh_cache, state) do
    new_state = get_weather_update()

    schedule_refresh()

    {:noreply, Map.merge(state, new_state)}
  end

  defp schedule_refresh do
    Process.send_after(self(), :refresh_cache, @refresh_interval)
  end

  def get_weather_update do
    %{ weather: Servy.Weather.get_weather() }
  end
end
