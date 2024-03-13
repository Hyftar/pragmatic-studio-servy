defmodule Servy do
  def hello do
    """
    GET /wildthings HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
    |> Servy.Handler.handle()
    |> IO.puts

    """
    GET /bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
    |> Servy.Handler.handle()
    |> IO.puts

    """
    GET /bigfoot HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
    |> Servy.Handler.handle()
    |> IO.puts

    """
    GET /bears/5 HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
    |> Servy.Handler.handle()
    |> IO.puts

    """
    GET /about HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
    |> Servy.Handler.handle()
    |> IO.puts

    """
    GET /bears/new HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """
    |> Servy.Handler.handle()
    |> IO.puts

    """
    POST /bears/new HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Content-Type: application/x-www-form-urlencoded
    Accept: */*

    name=Baloo&type=brown
    """
    |> Servy.Handler.handle()
    |> IO.puts

  end
end
