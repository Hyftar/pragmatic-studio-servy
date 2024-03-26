defmodule Servy.Weather do
  def get_weather() do
    :timer.sleep(:rand.uniform(500) + 500)

    %{
      "Miami" => %{ temperature: :rand.uniform(10) + 20, conditions: "sunny" },
      "Montreal" => %{ temperature: :rand.uniform(10), conditions: "rainy" },
      "Quebec" => %{ temperature: :rand.uniform(10), conditions: "chilly" },
      "Boston" => %{ temperature: :rand.uniform(10) + 5, conditions: "rainy" },
      "Shawinigan" => %{ temperature: :rand.uniform(10), conditions: "scattered clouds" },
      "New York" => %{ temperature: :rand.uniform(10) + 5, conditions: "cloudy" },
    }
  end
end
