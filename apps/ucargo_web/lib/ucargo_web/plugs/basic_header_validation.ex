defmodule UcargoWeb.BasicHeadersValidation do
  @moduledoc """
  Reads and validates headers from requests.
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    result =
    with  {:ok, conn} <- read_header(conn, "authorization"),
      do: {:ok, conn}

    case result do
      {:ok, conn} ->
        conn
      {:error, reason} ->
        conn
          |> send_resp(400, reason)
          |> halt
    end
  end

  defp read_header(conn, header) do
    case get_req_header(conn, header) do
      [] ->
        {:error, "El header #{header} es requerido"}
      [header_value] ->
        conn = assign(conn, String.to_atom(header), header_value)
        {:ok, conn}
    end
  end

end
