defmodule Ucargo.Pickup do
  @moduledoc """
  Ecto Pickup Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Ucargo.Pickup

  schema "pick_ups" do
    field :latitude, :decimal
    field :longitude, :decimal
    field :name, :string
    field :address, :string
    field :schedule, :string
    belongs_to :order, Ucargo.Order
    timestamps()
  end

  def create_changeset(%Pickup{} = pickup, attrs) do
    pickup
      |> cast(attrs, [:latitude, :longitude, :name, :address, :schedule, :order_id])
      |> validate_required([:latitude, :longitude])
      |> assoc_constraint(:order)
  end
end
