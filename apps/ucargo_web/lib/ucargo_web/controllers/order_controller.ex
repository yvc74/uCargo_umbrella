defmodule UcargoWeb.OrderController do
  @moduledoc """
  Controller for drivers
  """
  use UcargoWeb, :controller
  alias Ucargo.AvailableOrder
  alias Ucargo.Driver

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
