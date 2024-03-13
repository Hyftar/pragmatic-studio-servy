defmodule Servy.ProjectFile do
  def read(relative_path) do
    relative_path
    |> get_absolute_path
    |> File.read
  end

  def get_absolute_path(relative_path) do
    Path.expand("../../.", __DIR__)
    |> Path.join(relative_path)
  end
end
