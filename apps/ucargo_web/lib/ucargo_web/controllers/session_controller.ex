defmodule UcargoWeb.SessionController do
  use UcargoWeb, :controller

  alias Ucargo.Driver
  alias Ucargo.Guardian
  alias UcargoWeb.DriverJsonValidation
  require Logger

  action_fallback UcargoWeb.SessionFallbackController

  def signup(conn, params) do
    with {:ok, driver_params} <- DriverJsonValidation.sign_in(params) do
      changeset = Driver.signup_changeset(%Driver{}, driver_params)
      if changeset.valid? do
        driver = Driver.create(changeset)
        {:ok, token, _resource} = Guardian.encode_and_sign(driver)
        conn
          |> put_status(201)
          |> render("driver.json", %{user: driver, token: token})
      else
        changeset.errors
      end
    else
      {:error, error} ->
        {:error, error}
    end
  end

  def signin(conn, _params) do
    username = conn.assigns[:user]
    password = conn.assigns[:password]
    with {:ok, driver} <- Driver.log_in(username, password) do
      {:ok, token, _resource} = Guardian.encode_and_sign(driver)
      conn
        |> put_status(201)
        |> render("driver.json", %{user: driver, token: token})
    else
      {:error, error} ->
        {:error, error}
    end
  end
end
