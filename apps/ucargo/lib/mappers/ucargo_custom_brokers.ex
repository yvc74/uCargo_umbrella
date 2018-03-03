defmodule Ucargo.CustomBroker do
  @moduledoc """
  Ecto CustomBrokers Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Ucargo.CustomBroker

  schema "custom_brokers" do
    field :name, :string
    has_many :plannings, Ucargo.Planning
    many_to_many :drivers, Ucargo.Driver, join_through: "favourite_drivers"
  end

  def create_changeset(%CustomBroker{} = custombroker, attrs) do
    custombroker
      |> cast(attrs, [:name])
  end

  def update_changeset(%CustomBroker{} = custombroker, attrs) do
    custombroker
      |> cast(attrs, [:name])
  end
end
