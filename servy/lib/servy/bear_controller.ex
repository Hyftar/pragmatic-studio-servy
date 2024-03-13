defmodule Servy.BearController do

  alias Servy.ProjectFile
  alias Servy.FileHandler
  alias Servy.Wildthings
  alias Servy.Bear
  alias Servy.Conv
  alias Servy.View

  def index(%Conv{} = conv) do
    bears =
      Wildthings.list_bears
      |> Enum.sort(&Bear.order_by_name_asc/2)

    View.render(conv, "index.eex", bears: bears)
  end

  def show(%Conv{} = conv, id) do
    bear =
      Wildthings.list_bears
      |> Enum.find(fn(bear) -> bear.id == id end)

    View.render(conv, "show.eex", bear: bear)
  end

  def new(%Conv{} = conv) do
    ProjectFile.read("pages/form.html")
    |> FileHandler.handle_file(conv)
  end

  def create(%Conv{ params: %{ "type" => type, "name" => name } } = conv) do
    %{ conv | status: 201, resp_body: "Created a #{type} bear named #{name}!" }
  end

  def create_error(%Conv{} = conv) do
    %{ conv | status: 400, resp_body: "Failed to create a bear, missing params" }
  end
end
