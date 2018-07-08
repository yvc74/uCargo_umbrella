defmodule UcargoWeb.AssignmentController do
  use UcargoWeb, :controller
  alias Ucargo.Planning
  alias Ucargo.Order
  alias Ucargo.Guardian
  alias Ucargo.CustomBroker
  alias Ucargo.Bid
  alias Ucargo.Driver
  @export 1
  @import 0

  def index(conn, _params) do
    resource = Guardian.Plug.current_resource(conn)
    plannings = CustomBroker.fetch_assigned_plannings(resource)
    render conn, "index.html",
           assigned_items: Order.fetch_assigned_items(plannings), section_name: "assignments"
  end

  def new(conn, %{"bid_id" => bid_id, "planning_id" => planning_id}) do
    planning = Planning.find_by(:id, planning_id)
    bid = Bid.find_by(:id, bid_id)
    Planning.mark_as_winner(planning)
    Bid.mark_as_winner(bid)
    Order.create_assignment(planning.order, bid.driver)
    resource = Guardian.Plug.current_resource(conn)
    plannings = CustomBroker.fetch_assigned_plannings(resource)
    render conn, "index.html",
           assigned_items: Order.fetch_assigned_items(plannings), section_name: "assignments"
  end

  def assignment_detail(conn, %{"order_id" => order_id, "driver_id" => driver_id}) do
    order = Order.find_by(:id, order_id)
    [bid] =
    Enum.flat_map(order.planning.auction.bids, fn(bid) ->
      case bid.winner do
        true ->
          [bid]
        false ->
          []
      end
    end)

    resource = Guardian.Plug.current_resource(conn)
    driver = Driver.find_by(:id, driver_id)
    case order.type do
      @export ->
        render conn, "detail_export.html",
               order: order, planning: order.planning,
               custom_broker: resource, driver: driver, bid: bid, section_name: "assignments"
      @import ->
        render conn, "detail_import.html",
               order: order, planning: order.planning,
               custom_broker: resource, driver: driver, bid: bid, section_name: "assignments"
    end
  end
end
