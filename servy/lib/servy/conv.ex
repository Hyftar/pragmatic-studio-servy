defmodule Servy.Conv do
  alias Servy.Conv

  defstruct path: "",
            method: "",
            resp_body: "",
            resp_content_type: "text/html",
            status: nil,
            headers: %{},
            params: %{}

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{conv |> full_status}
    Content-Type: #{conv.resp_content_type}
    Content-Length: #{conv.resp_body |> byte_size}

    #{conv.resp_body}
    """
  end

  defp full_status(%Conv{} = conv) do
    "#{conv.status} #{conv.status |> status_reason}"
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end
