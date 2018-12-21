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
      custom: %{latitude: default(order.custom.latitude),
                longitude: default(order.custom.longitude),
                name: default(order.custom.name),
                attendant: default(order.custom.responsible),
                address: default(order.custom.address),
                schedule: default(order.custom.schedule),
                label: "custom"},
      deadline: generate_iso_date(order.deadline),
      delivery: %{latitude: default(order.delivery.latitude),
                  longitude: default(order.delivery.longitude),
                  name: default(order.delivery.name),
                  attendant: default(order.delivery.responsible),
                  address: default(order.delivery.address),
                  schedule: default(order.delivery.schedule),
                  label: "delivery"
                  },
      details: [%{label: "distance", value: default(order.distance)},
                %{label: "merchandise_type", value: default(order.merchandise_type)},
                %{label: "order_number", value: default(order.order_number)},
                %{label: "transport", value: default(order.transport)},
                %{label: "weight", value: default(order.weight)},
                %{label: "house_reference", value: default(order.planning.house_reference)},
                %{label: "master_reference", value: default(order.planning.master_reference)},
                %{label: "shipment_responsable", value: default(order.planning.custom_broker.company)},
                %{label: "ucargo_reference", value: default(order.id)}
               ],
     }
    if order.type == 1 do
      payload = %{latitude: default(order.pickup.latitude),
                longitude: default(order.pickup.longitude),
                name: default(order.pickup.name),
                attendant: default(order.pickup.responsible),
                address: default(order.pickup.address),
                schedule: default(order.pickup.schedule),
                label: "pickup"}
      Map.put(order_map, :pickup, payload)
    else
      order_map
    end
  end

  defp default(value) do
    case value do
      nil ->
        ""
      _ ->
        value
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
