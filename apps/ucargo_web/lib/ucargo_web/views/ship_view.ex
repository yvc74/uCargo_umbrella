defmodule UcargoWeb.ShipView do
  use UcargoWeb, :view
  def render_order_type(order_type) do
    if order_type== 0, do: "IMP", else: "EXP" 
  end

  def render_bid_status(auction) do
    if auction.bids == nil do
      ""
    end
  end

  def render_difference_date(begin_date_auction, end_date_auction) do
    difference = NaiveDateTime.diff(end_date_auction, begin_date_auction)
    difference/3600
  end
end
