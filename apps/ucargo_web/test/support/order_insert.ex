defmodule OrderInsertHelper do
  @moduledoc """
  Test file for order insert helper
  """
  alias Ucargo.Order
  alias Ucargo.Pickup
  alias Ucargo.Custom
  alias Ucargo.Delivery
  alias Ucargo.Planning
  alias Ucargo.CustomBroker
  alias Ucargo.Repo

  def create_order(driver) do
    orders_params = %{score: 4, deadline: NaiveDateTime.utc_now(),
                  status: "New", type: 1, distance: "350",
                  merchandise_type: "Plastic", order_number: "47848",
                  transport: "pick-up", weight: "800", comments: "None"}
    order = %Order{}
    order_chs = Order.create_changeset(order, orders_params)
    pick_up = %Pickup{}
    custom = %Custom{}
    delivery = %Delivery{} #32.5498703,-116.9378327
    pick_chgset = Pickup.create_changeset(pick_up,
            %{latitude: 32.5498703, longitude: -116.9378327,
              name: "Aduana de Tijuana", 
              address: "Garita Internacional, Perimetral Nte., 22430 Tijuana, B.C.",
              schedule: "sábado	9–15"})
    deliver_chgset = Delivery.create_changeset(delivery,
            %{latitude: 20.5848521, longitude: -100.3965839,
              name: "Plaza de toros Queretaro", 
              address: "Avenida Constituyentes, s/n, La Granja, 76190 Santiago de Querétaro, Qro.",
              schedule: "Lunes 9–15"})
    custom_import_chgset = Custom.create_changeset(custom,
            %{latitude: 32.5498703, longitude: -116.9378327,
              name: "Aduana de Tijuana", 
              address: "Garita Internacional, Perimetral Nte., 22430 Tijuana, B.C.",
              schedule: "sábado	9–15",
              responsible: "Benjamin Cedillo",
              date: "2018-03-10"})

    custom_broker = %CustomBroker{name: "Joel de la Peña",
              username: "joel65",
              password: "12345678",
              company: "Exportadora del Pácifico"}

    order_with_pick = Ecto.Changeset.put_assoc(order_chs, :pickup, pick_chgset)
    order_with_delivery = Ecto.Changeset.put_assoc(order_with_pick, :delivery, deliver_chgset)
    order_with_custom = Ecto.Changeset.put_assoc(order_with_delivery, :custom, custom_import_chgset)
    order_with_drivers = Ecto.Changeset.put_assoc(order_with_custom, :drivers, [driver])

    final_order = Repo.insert! order_with_drivers

    broker = Repo.insert!(custom_broker)

    pl_changeset = Planning.create_changeset(%Planning{},
                      %{master_reference: "115403",
                        house_reference: "142-3442-2576",
                        custom_broker_id: broker.id})
    pl_changeset_with_order = Ecto.Changeset.put_assoc(pl_changeset, :order, final_order)
    Repo.insert!(pl_changeset_with_order)
  end
end
