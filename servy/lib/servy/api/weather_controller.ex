defmodule Servy.Api.WeatherController do
  alias Servy.Conv

  def index(%Conv{}) do
    json =
      ["Montreal", "Shawinigan", "New York"]
      |> Enum.map(&Task.async(fn -> { &1, Servy.Weather.get_weather(&1) } end))
      |> Enum.map(&Task.await/1)
      |> Enum.into(%{}, fn { location, weather } -> { location, weather } end)
      |> Poison.encode!

    %{ %Conv{} | status: 200, resp_body: json, resp_content_type: "application/json" }
  end
end
