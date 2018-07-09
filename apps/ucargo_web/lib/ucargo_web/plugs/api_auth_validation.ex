defmodule Ucargo.Apiauth do
  @moduledoc """
  Validates session from headers values
  """
  import Plug.Conn
  alias Ucargo.Guardian
  @api_key "e70e918f-8035-48fc-a707-4507e1fd85c1"

  def init(opts), do: opts

  def call(conn, _opts) do
    result =
    with  {:ok, conn} <- validate_auth_token(conn),
          {:ok, conn} <- validate_api_key(conn),
      do: {:ok, conn}

    case result do
      {:ok, conn} ->
        conn
      {:error, reason} ->
        conn
          |> send_resp(401, reason)
          |> halt
    end
  end

  def validate_auth_token(conn) do
    auth_token = conn.assigns[:"x-auth-token"]
    case Guardian.resource_from_token(auth_token) do
      {:ok, resource, _claims} ->
        conn = assign(conn, :driver, resource)
        {:ok, conn}
      {:error, _} ->
        {:error, "x-auth-token its not valid or has expired"}
    end
  end

  def validate_api_key(conn) do
    api_key = conn.assigns[:"x-api-key"]
    case api_key == @api_key do
      true ->
        {:ok, conn}
      false ->
        {:error, "x-api-key its not valid"}
    end
  end
end