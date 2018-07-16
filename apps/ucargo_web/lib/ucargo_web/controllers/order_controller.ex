defmodule UcargoWeb.OrderController do
  @moduledoc """
  Controller for drivers
  """
  use UcargoWeb, :controller
  alias Ucargo.Order
  alias Ucargo.AvailableOrder

  def show(conn, _params) do
    driver = conn.assigns[:driver]
    available_orders = AvailableOrder.find_by(driver.id)
    conn
      |> put_status(200)
      |> render("available_orders.json", %{orders: available_orders})
  end
end
