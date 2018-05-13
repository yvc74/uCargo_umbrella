defmodule UcargoWeb.OrderController do
  @moduledoc """
  Controller for drivers
  """
  use UcargoWeb, :controller
  alias Ucargo.Order

  def show(conn, _params) do
    driver = conn.assigns[:driver]
    orders =  Order.find_assigned(driver)
    conn
      |> put_status(200)
      |> render("orders.json", %{orders: orders})
  end
end
