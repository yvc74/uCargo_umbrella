defmodule UcargoWeb.OrderView do
  use UcargoWeb, :view
  alias UcargoWeb.OrderView

  def render("orders.json", %{orders: orders}) do
    %{orders: render_many(orders, OrderView, "order.json")}
  end

  def render("order.json", %{order: order}) do
  	%{order_number: order.order_number}
  end
end
