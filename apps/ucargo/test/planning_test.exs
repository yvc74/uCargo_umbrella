defmodule Ucargo.PlanningTest do
  @moduledoc """
    Test File for plannings data layer
  """
  use Ucargo.DataCase
  alias Ucargo.CustomBroker
  alias Ucargo.Repo
  alias Ucargo.Planning

  setup do
    custom_broker_data =
    %CustomBroker{name: "Joel"}
    custom_broker = Repo.insert!(custom_broker_data)
    custom_broker = Repo.preload(custom_broker, :plannings)
    order_chg = Ucargo.CreateOrderHelper.all_data_order
    order = Repo.insert!(order_chg)
    {:ok, custom_broker: custom_broker, order: order}
  end

  test "create a new planning and assing to custom broker", %{custom_broker: custom_broker} do
    cb_changeset = CustomBroker.update_changeset(custom_broker, %{})
    pl_changeset = Planning.create_changeset(%Planning{}, %{})
    broker_with_planning = Ecto.Changeset.put_assoc(cb_changeset, :plannings, [pl_changeset])
    assert broker_with_planning.valid? == true
  end

  test "create a new planning and assign orders", %{order: order} do
    pl_changeset = Planning.create_changeset(%Planning{}, %{})
    pl_with_order = Ecto.Changeset.put_assoc(pl_changeset, :order, order)
    assert pl_with_order.valid? == true
  end

end
