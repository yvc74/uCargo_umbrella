defmodule Ucargo.DriverTest do
  @moduledoc """
    Test File for drivers data layer
  """
  use Ucargo.DataCase

    alias Ucargo.Driver
    alias Ucargo.CustomBroker
    alias Ucargo.Order

  test "Create Driver" do
    changeset = Driver.signup_changeset(%Driver{},
    %{username: "johndoe", password: "12345678", phone: "5534734763",
      email: "john@doe.com", picture: "picture", name: "John Doe"})
    assert changeset.valid? == true
  end

  test "Create Drivers, add custom broker to association" do
    driver = Driver.signup_changeset(%Driver{}, 
    %{username: "enriquelopez", password: "12345678", phone: "5527158727",
    email: "enrique@lopez.com", picture: "picture", name: "Enrique Lopez"})
    assert driver.valid? == true
    driver2 = Driver.signup_changeset(%Driver{}, 
    %{username: "joaquinperez", password: "12345678", phone: "5527159027",
    email: "joaquin@perez.com", picture: "picture", name: "Joaquin Perez"})
    assert driver2.valid? == true
    custom_broker = CustomBroker.create_changeset(%CustomBroker{}, %{name: "Antonio Romero"})
    assert custom_broker.valid? == true
    driver_with_custom_brokers = Ecto.Changeset.put_assoc(custom_broker, :drivers, [driver, driver2])
    assert driver_with_custom_brokers.valid? == true
  end

  test "create drivers, add order to association" do
    driver = Driver.signup_changeset(%Driver{}, 
    %{username: "arturogaona", password: "12345678", phone: "5598158727",
    email: "arturo@gaona.com", picture: "picture", name: "Arturo Goana"})
    assert driver.valid? == true
    order = Order.create_changeset(%Order{}, %{deadline: NaiveDateTime.utc_now()})
    assert order.valid? == true
    driver_with_orders = Ecto.Changeset.put_assoc(order, :drivers, [driver])
    assert driver_with_orders.valid? == true
  end


end
