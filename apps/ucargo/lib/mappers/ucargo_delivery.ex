defmodule Ucargo.Delivery do
  @moduledoc """
  Ecto Delivery Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Ucargo.Delivery

  schema "deliveries" do
    field :latitude, :decimal
    field :longitude, :decimal
    field :name, :string
    field :address, :string
    field :schedule, :string
    belongs_to :order, Ucargo.Order
    timestamps()
  end

  def create_changeset(%Delivery{} = delivery, attrs) do
    delivery
      |> cast(attrs, [:latitude, :longitude, :name, :address, :schedule, :order_id])
      |> validate_required([:latitude, :longitude])
      |> assoc_constraint(:order)
  end

end
