require Logger

defmodule Servy.Plugins do

  alias Servy.Conv

  def log(%Conv{} = conv), do: conv |> IO.inspect

  def track(%Conv{ method: method, path: path, status: 200 } = conv) do
    "#{method} request to path #{path}"
    |> Logger.info

    conv
  end

  def track(%Conv{ path: path, status: 404 } = conv) do
    "#{path} returned a 404"
    |> Logger.warning

    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{ path: "/wildlife" } = conv) do
    %{ conv | path: "wildthings" }
  end

  def rewrite_path(%Conv{ path: "/bears/?id=" <> id} = conv) do
    %{ conv | path: "/bears/#{id}" }
  end

  def rewrite_path(%Conv{} = conv), do: conv
end
