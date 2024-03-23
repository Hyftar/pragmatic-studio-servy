defmodule Servy.Parser do

  alias Servy.Conv

  def parse(request) do
    [head, body] = request |> String.split(~r"(\r|\n|\r\n){2}")
    [request_line | header_lines] = head |> String.split(~r"(\r|\n|\r\n)")
    [method, path, _] = request_line |> String.split(" ")

    headers = parse_headers(header_lines, %{})

    %Conv{
      path: path,
      method: method,
      headers: headers,
      params: parse_params(headers["Content-Type"], body),
    }
  end

  def parse_params("application/x-www-form-urlencoded", param_string) do
    param_string
    |> String.trim
    |> URI.decode_query
  end

  def parse_params(_, _), do: %{}

  def parse_headers([head | tail], headers) do
    [key, value] = head |> String.split(": ")

    tail
    |> parse_headers(Map.put(headers, key, value))
  end

  def parse_headers([], headers), do: headers
end
