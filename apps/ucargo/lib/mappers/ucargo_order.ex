defmodule Ucargo.Order do
  @moduledoc """
  Ecto Order Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Ucargo.Order
  #alias Ucargo.Repo

  schema "orders" do
    field :favorite, :boolean
    field :score, :integer
    field :deadline, :naive_datetime
    field :status, :string
    field :type, :integer
    field :distance, :string
    field :merchandise_type, :string
    field :order_number, :integer
    field :transport, :string
    field :weight, :string
    field :comments, :string
    belongs_to :driver, Ucargo.Driver
    has_one :pickup, Ucargo.Pickup
    has_one :delivery, Ucargo.Delivery
    timestamps()
  end

  def create_changeset(%Order{} = order, attrs) do
    order
      |> cast(attrs, [:favorite, :score, :deadline, :status, :type, :distance, :merchandise_type, :order_number, :transport, :weight, :comments, :driver_id])
      |> validate_required([:deadline])
      |> assoc_constraint(:driver)
  end
end
