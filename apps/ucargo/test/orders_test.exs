defmodule Ucargo.OrderTest do
  @moduledoc """
    Test File for Orders data layer
  """
  use Ucargo.DataCase
  alias Ucargo.Order
  alias Ucargo.Pickup
  alias Ucargo.Delivery

  test "Create Order" do
    order = %Ucargo.Order{}
    order_chs = Order.create_changeset(order,
                %{deadline: NaiveDateTime.utc_now()})
    assert order_chs.valid? == true
  end

  test "Create order with pick up" do
    order = %Order{}
    order_chs = Order.create_changeset(order,
                %{deadline: NaiveDateTime.utc_now()})
    pick_up = %Pickup{}
    pick_chgset = Pickup.create_changeset(pick_up,
                %{latitude: 34.332345, longitude: -99.345678})
    order_with_pick = Ecto.Changeset.put_assoc(order_chs, :pickup, pick_chgset)
    assert order_with_pick.valid? == true
  end

  test "Create order with pick up and delivery" do
    order = %Order{}
    order_chs = Order.create_changeset(order,
                %{deadline: NaiveDateTime.utc_now()})
    pick_up = %Pickup{}
    delivery = %Delivery{}
    pick_chgset = Pickup.create_changeset(pick_up,
                %{latitude: 34.332345, longitude: -99.345678})
    deliver_chgset = Delivery.create_changeset(delivery,
                %{latitude: 34.332345, longitude: -99.345678})
    order_with_pick = Ecto.Changeset.put_assoc(order_chs, :pickup, pick_chgset)
    order_with_delivery = Ecto.Changeset.put_assoc(order_with_pick, :delivery, deliver_chgset)
    assert order_with_pick.valid? == true
    assert order_with_delivery.valid? == true
  end
end
