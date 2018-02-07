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
          "account" => %{
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
              },
              "name" => %{
                "description" => "User name",
                "type" => "string"
              }
            },
            "required" => ["username", "password", "email", "picture", "name"]
          },
        },
        "additionalProperties" => :false,
        "required" => ["account"]
      }
      |> ExJsonSchema.Schema.resolve

    with :ok <- ExJsonSchema.Validator.validate(schema, params) do
      %{"account" => driver_params} = params
      {:ok, driver_params}
    else
      {:error, errors} -> json_error_parser(errors)
    end
  end

  def update(params) do
    schema =
      %{
        "title" => "Sign up schema",
        "type" => "object",
        "maxProperties" => 1,
        "properties" => %{
          "account" => %{
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
              },
              "name" => %{
                "description" => "User name",
                "type" => "string"
              }
            }
          },
        },
        "additionalProperties" => :false,
        "required" => ["account"]
      }
      |> ExJsonSchema.Schema.resolve

    with :ok <- ExJsonSchema.Validator.validate(schema, params) do
      %{"account" => driver_params} = params
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