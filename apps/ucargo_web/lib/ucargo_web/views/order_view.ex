defmodule UcargoWeb.OrderView do
  use UcargoWeb, :view
  alias UcargoWeb.OrderView

  def render("orders.json", %{orders: orders}) do
    %{orders: render_many(orders, OrderView, "order.json")}
  end

  def render("order.json", %{order: order}) do
    %{favorite: order.favourite,
      score: order.score,
      status: order.status,
      type: order.type,
      deadline: order.deadline,
      delivery: %{latitude: order.delivery.latitude,
                  longitude: order.delivery.longitude,
                  name: order.delivery.name,
                  address: order.delivery.address,
                  schedule: order.delivery.schedule
                  },
      pickup: %{latitude: order.pickup.latitude,
                longitude: order.pickup.longitude,
                name: order.pickup.name,
                address: order.pickup.address,
                schedule: order.pickup.schedule
               },
      details: [%{label: "distance", value: order.distance},
                %{label: "merchandise_type", value: order.merchandise_type},
                %{label: "order_number", value: order.order_number},
                %{label: "transport", value: order.transport},
                %{label: "weight", value: order.weight}
               ],
     }
  end
end
