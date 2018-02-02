defmodule UcargoWeb.DriverJsonValidation do
  @moduledoc """
  Module for Driver Json requests 
  """
  def sign_in(params) do
    schema =
      %{
        "title" => "Sign up schema",
        "type" => "object",
        "maxProperties" => 1,
        "properties" => %{
          "driver" => %{
            "type" => "object",
            "properties" => %{
             "username" =>  %{
              "description" => "Unique user name",
              "type" => "string"
                   },
             "password" => %{
             "description" => "Password",
              "type" => "string"
                   },
              "email" => %{
                "description" => "Driver email",
                "type" => "string"
              },
              "picture" => %{
                "description" => "User picture",
                "type" => "string"
              }
            },
            "required" => ["username", "password", "email", "picture"]
          },
        },
        "additionalProperties" => :false,
        "required" => ["driver"]
      }
      |> ExJsonSchema.Schema.resolve

    with :ok <- ExJsonSchema.Validator.validate(schema, params) do
      %{"driver" => driver_params} = params
      {:ok, driver_params}
    else
      {:error, errors} -> json_error_parser(errors)
    end
  end

  def json_error_parser(errors) do
    result =
      Enum.map(errors, fn {k, v} ->
        k = k
            |> String.replace("String", "")
            |> String.replace("\"", "")
            |> String.trim

        v = v
            |> String.replace("#", "")

        {:"#{v}", "#{k}"}
      end)
    {:error, result}
  end
end