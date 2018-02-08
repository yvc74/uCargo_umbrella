defmodule UcargoWeb.DriverController do
  @moduledoc """
  Controller for drivers
  """
  use UcargoWeb, :controller
  alias Ucargo.Driver
  alias Ucargo.Guardian
  alias UcargoWeb.DriverJsonValidation
  require Logger
  action_fallback UcargoWeb.SessionFallbackController

  def show(conn, _params) do
    driver = conn.assigns[:driver]
    conn
      |> put_status(200)
      |> json(%{driver: %{username: driver.username, email: driver.email}})
  end

  def update(conn, params) do
    driver = conn.assigns[:driver]
    with {:ok, driver_params} <- DriverJsonValidation.update(params) do
      changeset = Driver.update_changeset(driver, driver_params)
      if changeset.valid? do
        driver = Driver.update(changeset)
        {:ok, token, _resource} = Guardian.encode_and_sign(driver)
        conn
          |> put_status(200)
          |> render("driver.json", %{user: driver, token: token})
      else
        changeset.errors
      end
    else
      {:error, error} ->
        {:error, error}
    end
  end

  def orders(conn, _params) do

    origin = %{name: "origin 1", 
              latitude: "19.565331", 
              longitude: "-99.239541"
            }

    destination = %{name: "destination 1", 
                    latitude: "19.2059251", 
                    longitude: "-104.6792362"
                  }
    

    order = %{order_number: "123",
              origin: origin,
              destination: destination,
              type: 1,
              deadline: generate_iso_date(),
              favorite: true,
              distance: "400",
              transport: "pick-up",
              weight: "800",
              merchandise_type: "Plastic",
              pick_up_address: "Mexico City, 10350",
              pick_up_schedule: "February 10, 2018",
              score: 4,
              comments: "None",
              status: "New"
            }
    conn
      |> put_status(200)
      |> json(%{orders: [order, order]})
  end

  defp generate_iso_date do
    date = Timex.now |> Timex.shift(days: 7)
    case Timex.format(date, "{ISO:Basic}") do
      {:ok, value_date} ->
        value_date
      _->
        ""
    end

  end

  def order_delete(conn, _params) do
    conn
      |> put_status(200)
      |> render("order_delete.json", %{message: "Success"})
  end

  def order_quotes(conn, _params) do 
    conn
      |> put_status(200)
      |> render("order_quotes.json", %{quotes: "23500"})
  end

  def order_favorite(conn, _params) do
    conn
      |> put_status(200)
      |> render("order_favorite.json", %{message: "Success"})
  end

  def order_favorite_delete(conn, _params) do
    conn
    |> put_status(200)
    |> render("order_favorite_delete.json", %{message: "Success favorite delete"})
  end

end
