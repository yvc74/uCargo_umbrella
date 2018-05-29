defmodule UcargoWeb.SessionFallbackController do
  @moduledoc """
  Error controller for session controller
  """
  use  UcargoWeb, :controller

  def call(conn, {:error, changeset = %Ecto.Changeset{}}) do
    conn
      |> put_status(401)
      |> json(creation_error(changeset.errors))
  end

  def call(conn, {:error, errors}) do
    conn
      |> put_status(401)
      |> json(creation_error(errors))
  end

  def creation_error(errors) do
    details =
    cond do
      is_binary(errors) ->
        %{error:  "#{inspect errors}"}
      is_list(errors) ->
        result = errors
        |> Enum.map(fn {k, v} ->
            "#{k}: #{inspect v}"
          end)
        |> Enum.join(", ")

        %{error:  "#{inspect result}"}
      :true ->
        errors
    end
    %{message: "Session Error",
      level: "5",
      stage: "Session",
      details: details,
      code: "1401",
      http_code: 400}
  end
end
