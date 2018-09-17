defmodule UcargoWeb.OrderController do
  @moduledoc """
  Controller for drivers
  """
  use UcargoWeb, :controller
  alias Ucargo.AvailableOrder
  alias Ucargo.Driver

  def show_order(conn, %{"order_id" => order_id}) do
    driver = conn.assigns[:driver]
    case AvailableOrder.find_by(driver.id, order_id) do
      nil ->
        conn
          |> put_status(404)
          |> json(%{error: "Order with id: #{order_id} not found for this driver"})
      availaible_order ->
        conn
          |> put_status(200)
          |> render("available_order.json", %{order: availaible_order})
    end
  end

  def show(conn, %{"status" => "approved"}) do
    driver = conn.assigns[:driver]
    updated_driver = Driver.get_approved(driver)
    conn
      |> put_status(200)
      |> render("orders.json", %{orders: updated_driver.assigned_orders})
  end

  def show(conn, _params) do
    driver = conn.assigns[:driver]
    available_orders = AvailableOrder.find_by(driver.id)
    conn
      |> put_status(200)
      |> render("available_orders.json", %{orders: available_orders})
  end
end
