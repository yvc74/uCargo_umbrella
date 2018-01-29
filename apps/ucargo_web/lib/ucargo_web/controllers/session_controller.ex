defmodule UcargoWeb.SessionController do
  use UcargoWeb, :controller

  alias Ucargo.Driver
  alias Ucargo.Guardian
  alias UcargoWeb.DriverJsonValidation
  require Logger

  action_fallback UcargoWeb.SessionFallbackController

  def sign_in(conn, params) do
    with {:ok, driver_params} <- DriverJsonValidation.sign_in(params) do
      changeset = Driver.signup_changeset(%Driver{}, driver_params)
      if changeset.valid? do
        driver = Driver.create(changeset)
        {:ok, token, _resource} = Guardian.encode_and_sign(driver)
        conn
          |> put_status(201)
          |> json(%{token: token})
      else
        changeset.errors
      end
    else
      {:error, error} ->
        {:error, error}
    end
  end

  def login(conn, params) do
    %{"username" => username, "password" => password} = params["driver"]
    with {:ok, driver} <- Driver.log_in(username, password) do
      {:ok, token, _resource} = Guardian.encode_and_sign(driver)
      conn
        |> put_status(201)
        |> json(%{token: token})
    else
      {:error, error} ->
        {:error, error}
    end
  end
end
