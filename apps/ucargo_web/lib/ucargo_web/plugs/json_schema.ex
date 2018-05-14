defmodule UcargoWeb.JsonSchema do
  @moduledoc """
  Validates Json Body Against Json schema
  """
  import Plug.Conn
  use UcargoWeb, :router
  @unprocessable_entity_status 422

  @spec init(list(String.t())) :: list(String.t())
  def init(opts), do: opts

  def call(conn, _opts) do
    path =
      conn.path_info
      |> Path.join()
      |> transform_path()
    schema_name = Application.get_env(:ucargo_web, :json_validation)[:paths][path]
    schema = build_schema(schema_name)

    case validate(conn.body_params, schema) do
      {:ok, _} ->
        conn

      {:error, errors} ->
        response = build_error_response(errors, conn)

        conn
        |> put_status(@unprocessable_entity_status)
        |> json(response)
        |> halt
    end
  end

  def transform_path(path) do
    case Regex.match?(~r/^api\/v1\/drivers\/orders\/.*\/events$/, path) do
      true ->
        "api/v1/drivers/orders/events"
      false ->
        path
    end
  end

  def build_error_response(errors, conn) do
    %{stage:  "EVENTS JSON BODY",
      message: "JSON Body its incorrect",
      details: errors,
      headers: get_request_headers(conn)}
  end

  def validate(params, schema) do
    with :ok <- ExJsonSchema.Validator.validate(schema, params) do
      {:ok, params}
    else
      {:error, errors} -> json_error_parser(errors)
    end
  end

  defp get_request_headers(conn) do
    Enum.map(conn.req_headers, fn value ->
      {key, header} = value
      Map.put(%{}, key, header)
    end)
  end

  def build_schema(name) do
    schema = Application.get_env(:ucargo_web, :json_schemas)[name]
    ExJsonSchema.Schema.resolve(schema)
  end

  def json_error_parser(errors) do
    result =
      Enum.map(errors, fn {k, v} ->
        k =
          k
          |> String.replace("String", "")
          |> String.replace("\"", "")
          |> String.trim()

        v =
          v
          |> String.replace("#", "")

        %{:"#{v}" => "#{k}"}
      end)

    {:error, result}
  end
end
