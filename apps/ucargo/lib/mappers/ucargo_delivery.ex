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
    field :hour, :string, virtual: true
    field :minute, :string, virtual: true
    field :street, :string, virtual: true
    field :ext, :string, virtual: true
    field :int, :string, virtual: true
    field :neighborhood, :string, virtual: true
    field :state, :string, virtual: true
    field :responsible, :string
    field :date, :date
    belongs_to :order, Ucargo.Order
    timestamps()
  end

  def create_changeset(%Delivery{} = delivery, attrs) do
    delivery
      |> cast(attrs, [:latitude, :longitude, :name, :address, :schedule, :responsible, :date, :order_id])
      |> validate_required([:latitude, :longitude])
      |> assoc_constraint(:order)
  end

end
