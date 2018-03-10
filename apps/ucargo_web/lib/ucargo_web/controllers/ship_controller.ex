defmodule UcargoWeb.ShipController do
  use UcargoWeb, :controller
  alias Ucargo.Planning
  alias Ucargo.Order
  alias Ucargo.Pickup
  alias Ucargo.Delivery
  alias Ucargo.Guardian

  def index(conn, _params) do
    _resource = Guardian.Plug.current_resource(conn)
    plannings = Planning.find_all
    render conn, "index.html", plannings: plannings
  end

  def create(conn, _params) do
    changeset = Planning.create_changeset(%Planning{}, %{})
    render conn, "create.html", changeset: changeset
  end

  def show(conn, %{"id" => planning_id}) do
    planning = Planning.find_by(:id, planning_id)
    render conn, "show.html", planning: planning
  end

  def new(conn, params) do
    orders_params = %{score: 4, deadline: NaiveDateTime.utc_now(),
                  status: "New", type: 1, distance: "350",
                  merchandise_type: "Video", order_number: "47848",
                  transport: "pick-up", weight: "800", comments: "None"}
    order = %Order{}
    order_chs = Order.create_changeset(order, orders_params)
    %{"planning" => %{"order" => %{"delivery" => delivery_params, "pickup" => pick_up_params}}} = params
    pick_up = %Pickup{}
    delivery = %Delivery{}
    pk_up_prms = pick_up_params
      |> Map.put("latitude", 32.5498703)
      |> Map.put("longitude", -116.9378327)

    dvl_up_prms = delivery_params
      |> Map.put("latitude", 20.5848521)
      |> Map.put("longitude", -100.3965839)
      |> Map.put("name", "Centro Industrial Vallejo")

    pick_chgset = Pickup.create_changeset(pick_up, pk_up_prms)
    deliver_chgset = Delivery.create_changeset(delivery, dvl_up_prms)
    Planning.create_with_order(order_chs, pick_chgset, deliver_chgset)
    conn
      |> redirect(to: "/plannings")
  end
end
