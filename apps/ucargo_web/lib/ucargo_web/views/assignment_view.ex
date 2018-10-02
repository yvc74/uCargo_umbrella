defmodule UcargoWeb.AssignmentView  do
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

  def custom_route_status(order) do
    if order.status == "OnRouteToCustom" do
      "order-road__semaphore active"
    else
      "order-road__semaphore"
    end
  end

  def semaphore_light_status(order) do
    if order.status == "ReportedGreen" || order.status == "ReportedRed" do
      "order-road__semaphore active"
    else
      "order-road__semaphore"
    end
  end

  def lock_picture_status(order) do
    if order.status == "ReportedLock" do
      "order-road__semaphore active"
    else
      "order-road__semaphore"
    end
  end

  def store_merchandise_status(order) do
    if order.status == "Stored" do
      "order-road__semaphore active"
    else
      "order-road__semaphore"
    end
  end

  def delivered_to_client_status(order) do
    if order.status == "Signed" do
      "order-road__semaphore active"
    else
      "order-road__semaphore"
    end
  end

end
