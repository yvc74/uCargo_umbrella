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
    render conn, "index.html", plannings: broker.plannings, broker: broker
  end

  def new(conn, %{"bid_id" => bid_id, "planning_id" => planning_id}) do
    planning = Planning.find_by(:id, planning_id)
    bid = Bid.find_by(:id, bid_id)
    order = Order.create_assignment(planning.order, bid.driver)
    render conn, "index.html", planning: planning, order: order
  end
end
