defmodule UcargoWeb.RecordController do
  use UcargoWeb, :controller

  alias Ucargo.CustomBroker
  alias Ucargo.Order
  alias Ucargo.Guardian

  def index(conn, _params) do
    resource = Guardian.Plug.current_resource(conn)
    plannings = CustomBroker.fetch_assigned_plannings(resource)
    render conn, "index.html",
           assigned_items: Order.fetch_assigned_items(plannings), section_name: "records"
  end

end
