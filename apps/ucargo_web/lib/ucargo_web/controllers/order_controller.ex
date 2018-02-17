defmodule UcargoWeb.OrderController do
  @moduledoc """
  Controller for drivers
  """
  use UcargoWeb, :controller
  alias Ucargo.Order

  def show(conn, _params) do
    orders = Order.find_all
    conn
      |> put_status(200)
      |> render("orders.json", %{orders: orders})
  end
end
