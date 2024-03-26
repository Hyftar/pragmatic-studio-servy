defmodule Servy.Api.WeatherController do
  alias Servy.Conv

  def index(%Conv{}) do
    json =
      Servy.WeatherServer.get_weather_data()
      |> Poison.encode!

    %{ %Conv{} | status: 200, resp_body: json, resp_content_type: "application/json" }
  end
end
