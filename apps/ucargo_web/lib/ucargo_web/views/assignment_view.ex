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

  def custom_route_status_share_action(order) do
    if order.status == "OnRouteToCustom"
    || order.status == "ReportedGreen"
    || order.status == "ReportedRed"
    || order.status == "ReportedLock"
    || order.status == "Stored"
    || order.status == "OnRoute"
    || order.status == "OnTracking"
    || order.status == "Signed" do
      "visibility: visible"
    else
      "visibility: hidden"
    end
  end

  def custom_route_status(order) do
    if order.status == "OnRouteToCustom"
    || order.status == "ReportedGreen"
    || order.status == "ReportedRed"
    || order.status == "ReportedLock"
    || order.status == "Stored"
    || order.status == "OnRoute"
    || order.status == "OnTracking"
    || order.status == "Signed" do
      "order-road__semaphore active"
    else
      "order-road__semaphore"
    end
  end

  def semaphore_light_status_share_action(order) do
    if order.status == "ReportedGreen"
    || order.status == "ReportedRed"
    || order.status == "ReportedLock"
    || order.status == "Stored"
    || order.status == "OnRoute"
    || order.status == "OnTracking"
    || order.status == "Signed" do
      "visibility: visible"
    else
      "visibility: hidden"
    end
  end

  def semaphore_light_status(order) do
    if order.status == "ReportedGreen"
    || order.status == "ReportedRed"
    || order.status == "ReportedLock"
    || order.status == "Stored"
    || order.status == "OnRoute"
    || order.status == "OnTracking"
    || order.status == "Signed" do
      "order-road__semaphore active"
    else
      "order-road__semaphore"
    end
  end

  def picture_lock_actions(order) do
    if order.status == "ReportedLock"
    || order.status == "Stored"
    || order.status == "OnRoute"
    || order.status == "OnTracking"
    || order.status == "Signed" do
      "visibility: visible"
    else
      "visibility: hidden"
    end
  end

  def lock_picture_status(order) do
    if order.status == "ReportedLock"
    || order.status == "Stored"
    || order.status == "OnRoute"
    || order.status == "OnTracking"
    || order.status == "Signed" do
      "order-road__semaphore active"
    else
      "order-road__semaphore"
    end
  end

  def store_merchandise_actions(order) do
    if order.status == "Stored"
    || order.status == "OnRoute"
    || order.status == "OnTracking"
    || order.status == "Signed" do
      "visibility: visible"
    else
      "visibility: hidden"
    end
  end

  def store_merchandise_status(order) do
    if order.status == "Stored"
    || order.status == "OnRoute"
    || order.status == "OnTracking"
    || order.status == "Signed" do
      "order-road__semaphore active"
    else
      "order-road__semaphore"
    end
  end

  def on_route_actions(order) do
    if order.status == "OnRoute"
    || order.status == "OnTracking"
    || order.status == "Signed" do
      "visibility: visible"
    else
      "visibility: hidden"
    end
  end

  def on_route_status(order) do
    if order.status == "OnRoute"
    || order.status == "OnTracking"
    || order.status == "Signed" do
      "order-road__semaphore active"
    else
      "order-road__semaphore"
    end
  end

  def arrival_actions(order) do
    if order.status == "Signed" do
      "visibility: visible"
    else
      "visibility: hidden"
    end
  end

  def arrival_status(order) do
    if order.status == "Signed" do
      "order-road__semaphore active"
    else
      "order-road__semaphore"
    end
  end

  def delivered_to_client_actions(order) do
    if order.status == "Signed" do
      "visibility: visible"
    else
      "visibility: hidden"
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
