defmodule UcargoWeb.ShipController do
  use UcargoWeb, :controller
  alias Ucargo.Planning
  alias Ucargo.Order
  alias Ucargo.Pickup
  alias Ucargo.Delivery

  def index(conn, _params) do
    plannings = Planning.find_all
    render conn, "index.html", plannings: plannings
  end

  def create(conn, _params) do
    changeset = Planning.create_changeset(%Planning{}, %{})
    render conn, "create.html", changeset: changeset
  end

  def new(conn, params) do
    orders_params = %{score: 4, deadline: NaiveDateTime.utc_now(),
                  status: "New", type: 1, distance: "350",
                  merchandise_type: "Plastic", order_number: "47848",
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

    pick_chgset = Pickup.create_changeset(pick_up, pk_up_prms)
    deliver_chgset = Delivery.create_changeset(delivery, dvl_up_prms)
    Planning.create_with_order(order_chs, pick_chgset, deliver_chgset)
    conn
      |> redirect(to: "/plannings")
  end
  
  # orders_params = %{score: 4, deadline: NaiveDateTime.utc_now(),
  #                 status: "New", type: 1, distance: "350",
  #                 merchandise_type: "Plastic", order_number: "47848",
  #                 transport: "pick-up", weight: "800", comments: "None"}
# order = %Order{}
# order_chs = Order.create_changeset(order, orders_params)
# pick_up = %Pickup{}
# delivery = %Delivery{} #32.5498703,-116.9378327
# pick_chgset = Pickup.create_changeset(pick_up,
#             %{latitude: 32.5498703, longitude: -116.9378327,
#               name: "Aduana de Tijuana", 
#               address: "Garita Internacional, Perimetral Nte., 22430 Tijuana, B.C.",
#               schedule: "sábado	9–15"})
# deliver_chgset = Delivery.create_changeset(delivery,
#             %{latitude: 20.5848521, longitude: -100.3965839,
#               name: "Plaza de toros Queretaro", 
#               address: "Avenida Constituyentes, s/n, La Granja, 76190 Santiago de Querétaro, Qro.",
#               schedule: "Lunes 9–15"})
  
#   %{"planning" => 
#   %{"order" => %{"delivery" => %{"ext" => "122", "hour" => "12", "int" => "222", "minute" => "13", "neighborhood" => "Santa Maria", "schedule" => "", "state" => "CDMX", "street" => "Baltimore 72"},
#     "pickup" => %{"hour" => "12", "minute" => "13", "name" => "1", "schedule" => "07/03/2018"}}}}

end
