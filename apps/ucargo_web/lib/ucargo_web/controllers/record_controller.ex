defmodule UcargoWeb.RecordController do
  use UcargoWeb, :controller
  alias Ucargo.Planning
  alias Ucargo.Order
  alias Ucargo.Pickup
  alias Ucargo.Delivery
  alias Ucargo.Guardian
  alias Ucargo.CustomBroker
  alias Ucargo.Bid
  alias Ucargo.Custom
  @export 1
  @import 0


  def index(conn, _params) do
    broker = Guardian.Plug.current_resource(conn)
    plannings = CustomBroker.fetch_plannings(broker)
    render conn, "index.html", plannings: plannings, broker: broker
  end

end
