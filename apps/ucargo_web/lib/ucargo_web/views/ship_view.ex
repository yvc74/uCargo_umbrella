defmodule UcargoWeb.ShipView do
  use UcargoWeb, :view
  def render_order_type(order_type) do
    if (order_type== 0), do: "IMP", else: "EXP" 
  end

  def render_bid_status(auction) do
    if auction.bids == nil do
      ""
    end
  end
end
