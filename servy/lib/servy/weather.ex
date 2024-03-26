defmodule Servy.Weather do
  def get_weather(location) do
    :timer.sleep(:rand.uniform(500) + 500)

    locations = %{
      "Miami" => %{ temperature: 30, conditions: "sunny" },
      "Montreal" => %{ temperature: 8, conditions: "rainy" },
      "Quebec" => %{ temperature: 5, conditions: "sunny" },
      "Boston" => %{ temperature: 12, conditions: "rainy" },
      "Shawinigan" => %{ temperature: 3, conditions: "scattered clouds" },
      "New York" => %{ temperature: 11, conditions: "cloudy" },
    }

    Map.get(locations, location)
  end
end
