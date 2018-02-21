defmodule OrderInsertHelper do
  @moduledoc """
  Test file for order insert helper
  """
  alias Ucargo.Order
  alias Ucargo.Pickup
  alias Ucargo.Delivery
  alias Ucargo.Repo

  def create_order do
    orders_params = %{score: 4, deadline: NaiveDateTime.utc_now(),
                  status: "New", type: 1, distance: "350",
                  merchandise_type: "Plastic", order_number: "47848",
                  transport: "pick-up", weight: "800", comments: "None"}
    order = %Order{}
    order_chs = Order.create_changeset(order, orders_params)
    pick_up = %Pickup{}
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
    order_with_pick = Ecto.Changeset.put_assoc(order_chs, :pickup, pick_chgset)
    order_with_delivery = Ecto.Changeset.put_assoc(order_with_pick, :delivery, deliver_chgset)

    Repo.insert! order_with_delivery
  end
end
