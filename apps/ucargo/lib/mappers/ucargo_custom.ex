defmodule Ucargo.Custom do
  @moduledoc """
  Ecto Custom Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Ucargo.Custom

  schema "customs" do
    field :name, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :address, :string
    field :schedule, :string
    field :date, :date
    field :responsible, :string
    field :hour, :string, virtual: true
    field :minute, :string, virtual: true
    belongs_to :order, Ucargo.Order
    timestamps()
  end

  def create_changeset(%Custom{} = pickup, attrs) do
    pickup
      |> cast(attrs, [:latitude, :longitude, :name, :address, :schedule, :responsible, :date, :order_id])
      |> validate_required([:latitude, :longitude])
      |> assoc_constraint(:order)
  end
end
