defmodule UcargoWeb.DriverController do
  @moduledoc """
  Controller for drivers
  """
  use UcargoWeb, :controller
  use PhoenixSwagger
  alias Ucargo.{Driver, Guardian, EventDispatcher, CommonParameters, Order}
  alias UcargoWeb.{DriverJsonValidation}
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

  def swagger_definitions do
    %{
      OrderDeleteObjectSuccess: swagger_schema do
        title "DeleteOrderSuccessObject"
        description "Driver's order delete success"
        properties do
          message :string, "Success message"          
        end
        example %{
          message: "Success"          
        }
      end      
    }
  end

  swagger_path(:order_delete) do
    delete "/api/v1/driver/orders/{:orderId}"
    summary "Driver's order delete"
    description "Delete a order from id"
    produces "application/json"
    CommonParameters.authorization
    CommonParameters.order_id
    response 200, "OK", Schema.ref(:OrderDeleteObjectSuccess), example: %{
      help_number: "01800822746932"
    }
  end

  def order_delete(conn, _params) do
    conn
      |> put_status(200)
      |> render("order_delete.json", %{message: "Success"})
  end

  swagger_path(:order_quotes) do
    post "/api/v1/driver/orders/{orderId}/quotes"
    summary "Driver's order quote"
    description "quote a order from id"
    produces "application/json"
    CommonParameters.authorization
    CommonParameters.order_id
    response 200, "OK", Schema.ref(:OrderDeleteObjectSuccess), example: %{
      help_number: "01800822746932"
    }
  end

  def order_quotes(conn, _params) do 
    conn
      |> put_status(200)
      |> render("order_quotes.json", %{quotes: "23500"})
  end

  swagger_path(:order_favorite) do
    post "/api/v1/driver/orders/{orderId}/fav"
    summary "Driver's order quote"
    description "quote a order from id"
    produces "application/json"
    CommonParameters.authorization
    CommonParameters.order_id
    response 200, "OK", Schema.ref(:OrderDeleteObjectSuccess), example: %{
      help_number: "01800822746932"
    }
  end


  def order_favorite(conn, _params) do
    conn
      |> put_status(200)
      |> render("order_favorite.json", %{message: "Success"})
  end

  swagger_path(:order_favorite_delete) do
    post "/api/v1/driver/orders/{orderId}/fav"
    summary "Driver's order quote"
    description "quote a order from id"
    produces "application/json"
    CommonParameters.authorization
    CommonParameters.order_id
    response 200, "OK", Schema.ref(:OrderDeleteObjectSuccess), example: %{
      help_number: "01800822746932"
    }
  end

  def order_favorite_delete(conn, _params) do
    conn
    |> put_status(200)
    |> render("order_favorite_delete.json", %{message: "Success favorite delete"})
  end

  def order_onroute(conn, _params) do
    conn
      |> put_status(200)
      |> render("order_onroute.json", %{order: "0001"})
  end

  def events(conn, %{"order_numer" => order_number, "event" => event}) do
    %{"date" => date} = event
    with {:ok, order} <- Order.validate_order_id(order_number),
         {:ok, event} <- EventDispatcher.dispatch(event, date, order) do
      conn
        |> put_status(200)
        |> render("event.json", %{event: event})
    else
      {:error, error} ->
        {:error, error}
    end
  end
end
