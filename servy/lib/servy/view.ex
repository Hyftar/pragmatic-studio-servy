defmodule Servy.View do
  alias Servy.Conv
  alias Servy.ProjectFile

  def render(%Conv{} = conv, template, bindings \\ []) do
    content =
      "templates/#{template}"
      |> ProjectFile.get_absolute_path
      |> EEx.eval_file(bindings)

    %Conv{ conv | status: 200, resp_body: content }
  end
end
