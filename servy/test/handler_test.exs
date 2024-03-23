defmodule HandlerTest do
  use ExUnit.Case

  import Servy.Handler

  test "GET /wildthings" do
    request = """
    GET /wildthings HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Bears, Lions, Tigers
    """
  end

  test "GET /bears" do
    request = """
    GET /bears HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 336

    <h1>All The Bears!</h1>

    <ul>
      <li>Brutus - Grizzly</li>
      <li>Iceman - Polar</li>
      <li>Kenai - Grizzly</li>
      <li>Paddington - Brown</li>
      <li>Roscoe - Panda</li>
      <li>Rosie - Black</li>
      <li>Scarface - Grizzly</li>
      <li>Smokey - Black</li>
      <li>Snow - Polar</li>
      <li>Teddy - Brown</li>
    </ul>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /bigfoot" do
    request = """
    GET /bigfoot HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    assert response == """
    HTTP/1.1 404 Not Found
    Content-Type: text/html
    Content-Length: 39

    No /bigfoot path with method GET found!
    """
  end

  test "GET /bears/1" do
    request = """
    GET /bears/1 HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 73

    <h1>Show Bear</h1>
    <p>
    Is Teddy hibernating? <strong>yes</strong>
    </p>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /wildlife" do
    request = """
    GET /wildlife HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Bears, Lions, Tigers
    """
  end

  test "GET /about" do
    request = """
    GET /about HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 102

    <h1>Clark's Wildthings Refuge</h1>

    <blockquote>
    When we contemplate the whole globe...
    </blockquote>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /bears/new" do
    request = """
    POST /bears/new HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*
    Content-Type: application/x-www-form-urlencoded
    Content-Length: 21

    name=Baloo&type=Brown
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 201 Created
    Content-Type: text/html
    Content-Length: 33

    Created a Brown bear named Baloo!
    """
  end

  test "GET /api/bears" do
  request = """
  GET /api/bears HTTP/1.1
  Host: example.com
  User-Agent: ExampleBrowser/1.0
  Accept: */*

  """

  response = handle(request)

  expected_response = """
  HTTP/1.1 200 OK
  Content-Type: application/json
  Content-Length: 605

  [
    {"hibernating":true,"type":"Brown","name":"Teddy","id":1},
    {"hibernating":false,"type":"Black","name":"Smokey","id":2},
    {"hibernating":false,"type":"Brown","name":"Paddington","id":3},
    {"hibernating":true,"type":"Grizzly","name":"Scarface","id":4},
    {"hibernating":false,"type":"Polar","name":"Snow","id":5},
    {"hibernating":false,"type":"Grizzly","name":"Brutus","id":6},
    {"hibernating":true,"type":"Black","name":"Rosie","id":7},
    {"hibernating":false,"type":"Panda","name":"Roscoe","id":8},
    {"hibernating":true,"type":"Polar","name":"Iceman","id":9},
    {"hibernating":false,"type":"Grizzly","name":"Kenai","id":10}
  ]
  """

  assert remove_whitespace(response) == remove_whitespace(expected_response)
end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
