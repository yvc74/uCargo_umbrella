defmodule UcargoWeb.AssignmentController do
  use UcargoWeb, :controller
  alias Ucargo.Planning
  alias Ucargo.Order
  alias Ucargo.Guardian
  alias Ucargo.CustomBroker
  alias Ucargo.Bid

  def index(conn, _params) do
    resource = Guardian.Plug.current_resource(conn)
    broker = CustomBroker.fetch_plannings(resource)
    render conn, "index.html",
           assigned_items: Order.fetch_assigned_items(broker.plannings)
  end

  def new(conn, %{"bid_id" => bid_id, "planning_id" => planning_id}) do
    planning = Planning.find_by(:id, planning_id)
    bid = Bid.find_by(:id, bid_id)
    Order.create_assignment(planning.order, bid.driver)
    resource = Guardian.Plug.current_resource(conn)
    broker = CustomBroker.fetch_plannings(resource)
    render conn, "index.html",
           assigned_items: Order.fetch_assigned_items(broker.plannings)
  end
end
