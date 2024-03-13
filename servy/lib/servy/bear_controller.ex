defmodule Servy.BearController do
  import Servy.ProjectFile
  import Servy.FileHandler

  alias Servy.Wildthings
  alias Servy.Bear
  alias Servy.Conv

  def index(%Conv{} = conv) do
    bears_list =
      Wildthings.list_bears
      |> Enum.filter(&Bear.is_grizzly/1)
      |> Enum.sort(&Bear.order_by_name_asc/2)
      |> Enum.map(&bear_list_item/1)
      |> Enum.join("\n")

    %Conv{ conv | status: 200, resp_body: "<ul>\n#{bears_list}\n</ul>" }
  end

  defp bear_list_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end

  def new(%Conv{} = conv) do
    read("pages/form.html")
    |> handle_file(conv)
  end

  def create(%Conv{ params: %{ "type" => type, "name" => name } } = conv) do
    %{ conv | status: 201, resp_body: "Created a #{type} bear named #{name}!" }
  end

  def create_error(%Conv{} = conv) do
    %{ conv | status: 400, resp_body: "Failed to create a bear, missing params" }
  end

  def show(%Conv{} = conv, id) do
    bear =
      Wildthings.list_bears
      |> Enum.find(fn(bear) -> bear.id == id end)

    %Conv{ conv | status: 200, resp_body: "<h1>#{bear.name} - id: #{bear.id}</h1>" }
  end
end
