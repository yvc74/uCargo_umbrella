defmodule UcargoWeb.DriverFallbackController do
  @moduledoc """
  Error controller for session controller
  """
  use  UcargoWeb, :controller

  def call(conn, {:error, changeset = %Ecto.Changeset{}}) do
    conn
      |> put_status(400)
      |> json(creation_error(changeset.errors))
  end

  def call(conn, {:error, errors}) do
    conn
      |> put_status(400)
      |> json(creation_error(errors))
  end

  def creation_error(errors) do
    details =
    cond do
      is_binary(errors) ->
        %{error:  "#{inspect errors}"}
      is_list(errors) ->
        result = errors
        |> Enum.map(fn {key, val} ->
            "#{key}: #{inspect val}"
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
      code: "1402",
      http_code: 400}
  end
end