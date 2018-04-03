defmodule UcargoWeb.ShipView do
  use UcargoWeb, :view
  def render_order_type(order_type) do
    if order_type== 0, do: "IMPORTACIÓN", else: "EXPORTACIÓN"
  end

  def render_bid_status(auction) do
    if auction.bids == nil do
      ""
    end
  end

  def render_difference_date(begin_date_auction, end_date_auction) do
    difference = NaiveDateTime.diff(end_date_auction, begin_date_auction)
    Integer.floor_div(difference, 3600)
  end

  def render_uppercase(string) do
    String.upcase(string)
  end

  def render_avalaible_bids(planning) do
    IO.inspect planning
    if planning.auction.bids == [] do
      "Sin Propuestas"
    else
      "Ver Propuestas"
    end
  end

end
