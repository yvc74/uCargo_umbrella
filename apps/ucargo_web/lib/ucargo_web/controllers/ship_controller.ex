defmodule UcargoWeb.ShipController do
  use UcargoWeb, :controller
  alias Ucargo.Planning
  alias Ucargo.Order
  alias Ucargo.Pickup
  alias Ucargo.Delivery
  alias Ucargo.Guardian
  alias Ucargo.CustomBroker
  alias Ucargo.Bid
  alias Ucargo.Custom
  alias Ucargo.TransportCatalog
  alias Ucargo.CustomCatalog
  alias Ucargo.State
  alias Ucargo.Driver
  @export 1
  @import 0

  def index(conn, _params) do
    broker = Guardian.Plug.current_resource(conn)
    plannings = CustomBroker.fetch_plannings(broker)
    render conn, "index.html", plannings: plannings, broker: broker, section_name: "plannings"
  end

  def proposal_index(conn, %{"id" => planning_id}) do
    planning = Planning.find_by(:id, planning_id)
    render conn, "proposal.html", planning: planning, section_name: "plannings"
  end

  def create(conn, %{"type" => planning_type}) do
    transport_catalog = TransportCatalog.fetch_all_transport_catalog
    custom_catalog_all = CustomCatalog.fetch_all_custom_catalog
    states = State.all
    case planning_type do
      "import" ->
        changeset = Planning.create_changeset(%Planning{}, %{})
        render conn, "create_import.html", changeset: changeset, section_name: "plannings", transport_catalog: transport_catalog, custom_catalog: custom_catalog_all, states: states
      "export" ->
        changeset = Planning.create_changeset(%Planning{}, %{})
        render conn, "create_export.html", changeset: changeset, section_name: "plannings", transport_catalog: transport_catalog, custom_catalog: custom_catalog_all, states: states
    end
  end

  def show(conn, %{"planning_id" => planning_id, "bid_id" => bid_id}) do
    planning = Planning.find_by(:id, planning_id)
    bid = Bid.find_by(:id, bid_id)
    case planning.order.type do
      @export ->
        render conn, "show_export.html", planning: planning, bid: bid, section_name: "plannings"
      @import ->
        render conn, "show_import.html", planning: planning, bid: bid, section_name: "plannings"
    end
  end

  def payment_show(conn, %{"planning_id" => planning_id, "bid_id" => bid_id}) do
    planning = Planning.find_by(:id, planning_id)
    bid = Bid.find_by(:id, bid_id)
    render conn, "payment_detail.html", planning: planning, bid: bid, section_name: "plannings"
  end

  def new(conn, params) do
    broker = Guardian.Plug.current_resource(conn)
    %{"planning" => %{"master_reference" => master_reference_params, "house_reference" => house_reference_params, "order" => %{"delivery" => delivery_params, "custom" => custom_params} = order_params}} = params
    order = %Order{}
    custom = %Custom{}
    delivery = %Delivery{}
    order_up_prms = order_params
      |> Map.put("score", 4)
      |> Map.put("distance", "500")
      |> Map.put("order_number", "47848")
      |> Map.put("status", "New")
      |> Map.put("deadline", NaiveDateTime.utc_now())
    order_chs = Order.create_changeset(order, order_up_prms)
    drivers = Driver.fetch_all
    order_with_drivers_chs = Ecto.Changeset.put_assoc(order_chs, :drivers, drivers)
    {:ok, custom_catalog} = CustomCatalog.get_by_name(custom_params["name"])
    ct_up_prms = custom_params
      |> Map.put("latitude", "#{custom_catalog.latitude}")
      |> Map.put("longitude", "#{custom_catalog.longitude}")
      |> Map.put("schedule", "#{custom_catalog.schedule}")
      |> Map.put("address", "#{custom_catalog.address}")

    dvl_up_prms = delivery_params
      |> Map.put("latitude", 20.5848521)
      |> Map.put("longitude", -100.3965839)
      |> Map.put("name", "#{delivery_params["street"]} #{delivery_params["ext"]} #{delivery_params["int"]}, #{delivery_params["zipcode"]}, #{delivery_params["neighborhood"]},#{delivery_params["delegation"]},#{delivery_params["city"]},#{delivery_params["state"]}")
      |> Map.put("address", "#{delivery_params["street"]} #{delivery_params["ext"]} #{delivery_params["int"]}, #{delivery_params["zipcode"]}, #{delivery_params["neighborhood"]},#{delivery_params["delegation"]},#{delivery_params["city"]},#{delivery_params["state"]}")

    cstm_chgset = Custom.create_changeset(custom, ct_up_prms)
    deliver_chgset = Delivery.create_changeset(delivery, dvl_up_prms)
    Planning.create_with_order_import({master_reference_params, house_reference_params, order_with_drivers_chs, cstm_chgset, deliver_chgset, broker.id})
    conn
      |> redirect(to: "/plannings")
  end

  def new_export_ship(conn, params) do
    broker = Guardian.Plug.current_resource(conn)
    %{"planning" => %{"master_reference" => master_reference_params, "house_reference" => house_reference_params, "order" => %{"delivery" => delivery_params, "custom" => custom_params, "pickup" => pickup_params} = order_params}} = params
    order = %Order{}
    custom = %Custom{}
    delivery = %Delivery{}
    pickup = %Pickup{}
    {:ok, _custom_catalog} = CustomCatalog.get_by_name(custom_params["name"])
    order_up_prms = order_params
      |> Map.put("score", 4)
      |> Map.put("distance", "500")
      |> Map.put("order_number", "47848")
      |> Map.put("deadline", NaiveDateTime.utc_now())
    order_chs = Order.create_changeset(order, order_up_prms)

    ct_up_prms = custom_params
      |> Map.put("latitude", 32.5498703)
      |> Map.put("longitude", -116.9378327)
      |> Map.put("name", "#{custom_params["street"]} custom")
      |> Map.put("address", "#{custom_params["street"]} #{custom_params["ext"]} #{custom_params["int"]}, #{custom_params["zipcode"]}, #{custom_params["neighborhood"]},#{custom_params["delegation"]},#{custom_params["city"]},#{custom_params["state"]}")

    dvl_up_prms = delivery_params
      |> Map.put("latitude", 20.5848521)
      |> Map.put("longitude", -100.3965839)
      |> Map.put("name", "#{delivery_params["street"]} delivery")
      |> Map.put("address", "#{delivery_params["street"]} #{delivery_params["ext"]} #{delivery_params["int"]}, #{delivery_params["zipcode"]}, #{delivery_params["neighborhood"]},#{delivery_params["delegation"]},#{delivery_params["city"]},#{delivery_params["state"]}")

    pck_up_prms = pickup_params
      |> Map.put("latitude", 20.5848521)
      |> Map.put("longitude", -100.3965839)
      |> Map.put("name", "#{pickup_params["street"]} pickup")
      |> Map.put("address", "#{pickup_params["street"]} #{pickup_params["ext"]} #{pickup_params["int"]}, #{pickup_params["zipcode"]}, #{pickup_params["neighborhood"]},#{pickup_params["delegation"]},#{pickup_params["city"]},#{pickup_params["state"]}")      

    cstm_chgset = Custom.create_changeset(custom, ct_up_prms)
    deliver_chgset = Delivery.create_changeset(delivery, dvl_up_prms)
    pck_chgset = Pickup.create_changeset(pickup, pck_up_prms)

    Planning.create_with_order_export({master_reference_params,
                                       house_reference_params,
                                       order_chs, cstm_chgset,
                                       pck_chgset, deliver_chgset,
                                       broker.id})
    conn
      |> redirect(to: "/plannings")
  end
end
