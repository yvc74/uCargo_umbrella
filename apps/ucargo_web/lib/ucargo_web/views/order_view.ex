defmodule UcargoWeb.OrderView do
  use UcargoWeb, :view
  alias UcargoWeb.OrderView

  def render("available_orders.json", %{orders: orders}) do
    %{orders: render_many(orders, OrderView, "available_order.json")}
  end

  def render("orders.json", %{orders: orders}) do
    %{orders: render_many(orders, OrderView, "order.json")}
  end

  def render("available_order.json", %{order: avalaible_order}) do
    order = order_object(avalaible_order.order)
    if avalaible_order.bid == nil do
      %{order | status: "New"}
    else
      %{order | quoted_price: avalaible_order.bid.price, status: order.status}
    end
  end

  def render("order.json", %{order: order}) do
    price = get_winner_bid_price(order)
    order = order_object(order)
    %{order | quoted_price: price}
  end

  defp order_object(order) do
    order_map =
    %{id: order.id,
      favorite: order.favourite,
      score: order.score,
      status: order.status,
      quoted_price: 0,
      type: order.type,
      custom: %{latitude: order.custom.latitude,
                longitude: order.custom.longitude,
                name: order.custom.name,
                attendant: order.custom.responsible,
                address: order.custom.address,
                schedule: order.custom.schedule,
                label: "custom"},
      deadline: generate_iso_date(order.deadline),
      delivery: %{latitude: order.delivery.latitude,
                  longitude: order.delivery.longitude,
                  name: order.delivery.name,
                  attendant: order.delivery.responsible,
                  address: order.delivery.address,
                  schedule: order.delivery.schedule,
                  label: "delivery"
                  },
      details: [%{label: "distance", value: order.distance},
                %{label: "merchandise_type", value: order.merchandise_type},
                %{label: "order_number", value: order.order_number},
                %{label: "transport", value: order.transport},
                %{label: "weight", value: order.weight},
                %{label: "house_reference", value: order.planning.house_reference},
                %{label: "master_reference", value: order.planning.master_reference},
                %{label: "shipment_responsable", value: order.planning.custom_broker.company},
                %{label: "ucargo_reference", value: order.id}
               ],
     }
    if order.type == 1 do
      payload = %{latitude: order.pickup.latitude,
                longitude: order.pickup.longitude,
                name: order.pickup.name,
                attendant: order.pickup.responsible,
                address: order.pickup.address,
                schedule: order.pickup.schedule,
                label: "pickup"}
      Map.put(order_map, :pickup, payload)
    else
      order_map
    end
  end

  def get_winner_bid_price(order) do
    bids = order.planning.auction.bids
    results =
    Enum.flat_map(bids, fn(bid) ->
      if bid.winner do
        [bid]
      else
        []
      end
    end)
    case results do
      [] ->
        0
      [bid] ->
        bid.price
    end
  end

  defp generate_iso_date(date) do
    Timex.format!(Timex.to_datetime(date, "America/Chicago"), "{ISO:Extended}")
  end
end
