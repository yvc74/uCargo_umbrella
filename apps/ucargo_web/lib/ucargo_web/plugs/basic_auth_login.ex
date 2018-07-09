defmodule Ucargo.BasicAuth do
  @moduledoc """
  Validates session from headers values
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    result =
    with  {:ok, conn} <- validate_basic_auth(conn),
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

  def validate_basic_auth(conn) do
    basic_token = conn.assigns[:authorization]
    with {:ok, challenge} <- validate_realm(basic_token),
         {:ok, credentials} <- validate_base64(challenge),
         {:ok, {user, password}} <- split_credentials(credentials) do

      result = conn
        |> assign(:user, user)
        |> assign(:password, password)
      {:ok, result}
    else
      {:error, error} ->
        {:error, error}
    end
  end

  def validate_realm(token) do
    case String.contains?(token, "Basic ") do
      true ->
        {:ok, String.replace(token, "Basic ", "")}
      false ->
        {:error, "Invalid basic authorization format"}
    end
  end

  def validate_base64(challenge) do
    case Base.decode64(challenge) do
      {:ok, credentials} ->
        {:ok, credentials}
      :error ->
        {:error, "Credentials are not in base 64"}
    end
  end

  def split_credentials(credentials) do
    case String.split(credentials, ":") do
      [user, password] ->
        {:ok, {user, password}}
      _ ->
        {:error, "Invalid basic authorization format"}
    end
  end

end
