defmodule UcargoWeb.OrderView do
  use UcargoWeb, :view
  alias UcargoWeb.OrderView

  def render("orders.json", %{orders: orders}) do
    %{orders: render_many(orders, OrderView, "order.json")}
  end

  def render("order.json", %{order: order}) do
    order_map =
    %{id: order.id,
      favorite: order.favourite,
      score: order.score,
      status: order.status,
      type: order.type,
      custom: %{latitude: order.custom.latitude,
                longitude: order.custom.longitude,
                name: order.custom.name,
                address: order.custom.address,
                schedule: order.custom.schedule},
      deadline: generate_iso_date(order.deadline),
      delivery: %{latitude: order.delivery.latitude,
                  longitude: order.delivery.longitude,
                  name: order.delivery.name,
                  address: order.delivery.address,
                  schedule: order.delivery.schedule
                  },
      details: [%{label: "distance", value: order.distance},
                %{label: "merchandise_type", value: order.merchandise_type},
                %{label: "order_number", value: order.order_number},
                %{label: "transport", value: order.transport},
                %{label: "weight", value: order.weight}
               ],
     }
    if order.type == 1 do
      payload = %{latitude: order.pickup.latitude,
                longitude: order.pickup.longitude,
                name: order.pickup.name,
                address: order.pickup.address,
                schedule: order.pickup.schedule}
      Map.put(order_map, :pickup, payload)
    else
      order_map
    end
  end

  defp generate_iso_date(date) do
    Timex.format!(Timex.to_datetime(date, "America/Chicago"), "{ISO:Extended}")
  end
end
