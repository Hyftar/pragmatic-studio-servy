defmodule Servy.ProjectFile do
  def read(relative_path) do
    Path.expand("../../.", __DIR__)
    |> Path.join(relative_path)
    |> File.read
  end
end
