defmodule UcargoWeb.RecordView  do
  use UcargoWeb, :view

  def render_order_type(order_type) do
    if order_type == 0, do: "IMPORTACIÓN", else: "EXPORTACIÓN"
  end

  def render_difference_date(begin_date_auction, end_date_auction) do
    difference = NaiveDateTime.diff(end_date_auction, begin_date_auction)
    Integer.floor_div(difference, 3600)
  end

  def render_uppercase(string) do
    String.upcase(string)
  end

  def render_price(planning) do
    bids = planning.auction.bids
    result =
    Enum.flat_map(bids, fn bid ->
      if bid.winner do
        [bid]
      else
        []
      end
    end)
    case result do
      [] ->
        "$0.0"
      [bid] ->
        "$ #{bid.price}"
    end
  end

end
