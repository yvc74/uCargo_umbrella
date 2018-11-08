defmodule UcargoWeb.SessionFallbackController do
  @moduledoc """
  Error controller for session controller
  """
  use  UcargoWeb, :controller
  alias Ucargo.CustomBroker

  def call(conn, [not_found: error]) do
    changeset = CustomBroker.create_changeset(%CustomBroker{}, %{})
    render conn, "signin.html", changeset: changeset, session_error: true
  end

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
    %{message: "Insert Error",
      level: "5",
      stage: "Insert",
      details: details,
      code: "1401",
      http_code: 400}
  end
end
