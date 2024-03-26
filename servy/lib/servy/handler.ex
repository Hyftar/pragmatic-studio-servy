require Logger

defmodule Servy.Handler do
  import Servy.Plugins
  import Servy.ProjectFile
  import Servy.Parser
  import Servy.FileHandler

  alias Servy.Conv
  alias Servy.BearController

  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> route
    # |> log
    # |> track
    # |> emojify
    |> Conv.format_response
  end

  def route(%Conv{ method: "GET", path: "/wildthings" } = conv) do
    %Conv{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%Conv{ method: "GET", path: "/bears" } = conv) do
    conv
    |> BearController.index
  end

  def route(%Conv{ method: "GET", path: "/api/bears" } = conv) do
    conv
    |> Servy.Api.BearController.index
  end

  def route(%Conv{ method: "GET", path: "/api/weather" } = conv) do
    conv
    |> Servy.Api.WeatherController.index
  end

  def route(%Conv{ method: "GET", path: "/bears/new" } = conv) do
    conv
    |> BearController.new
  end

  def route(%Conv{ method: "POST", path: "/bears/new", params: %{ "type" => _, "name" => _ } } = conv) do
    conv
    |> BearController.create
  end

  def route(%Conv{ method: "POST", path: "/bears/new", params: %{ } } = conv) do
    conv
    |> BearController.create_error
  end

  def route(%Conv{ method: "GET", path: "/bears/" <> id } = conv) do
    id = id |> String.to_integer

    conv
    |> BearController.show(id)
  end

  def route(%Conv{ method: "GET", path: "/about" } = conv) do
    read("pages/about.html")
    |> handle_file(conv)
  end

  def route(%Conv{ method: method, path: path } = conv) do
    %Conv{ conv | status: 404, resp_body: "No #{path} path with method #{method} found!"}
  end

  def emojify(%Conv{ status: 200, resp_body: resp_body } = conv) do
    confetti_line = "🎉" |> String.duplicate(5)
    %Conv{ conv | resp_body:  confetti_line <> "\n" <> resp_body <> "\n"  <> confetti_line}
  end

  def emojify(%Conv{} = conv), do: conv
end
