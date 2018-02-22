defmodule Ucargo.CustomBroker do
  @moduledoc """
  Ecto CustomBrokers Mapper
  """
  use Ecto.Schema

  schema "custom_brokers" do
    field :name, :string
    has_many :plannings, Ucargo.Planning
    many_to_many :drivers, Ucargo.Driver, join_through: "favourite_drivers"
  end

end
