defmodule UcargoWeb.DriverView do
	use UcargoWeb, :view
	alias UcargoWeb.DriverView
	require Logger

	def render("orders.json", %{orders: orders}) do	
    render_many(orders, DriverView, "order.json", as: :order)
  end

	def render("order.json", %{order: order}) do
  	%{order_number: order.order_number,
    	origin: order.origin,
      destination: order.destination,
      type: order.type,
      deadline: order.deadline,
      favorite: order.favorite,
      distance: order.distance,
      transport: order.transport,
      weight: order.weight,
      merchandise_type: order.merchandise_type,
      pick_up_address: order.pick_up_address,
      pick_up_schedule: order.pick_up_schedule,
      score: order.score,
      comments: order.comments,
      status: order.status
    }
  end
end