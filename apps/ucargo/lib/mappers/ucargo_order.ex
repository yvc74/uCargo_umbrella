defmodule Ucargo.Order do
  @moduledoc """
  Ecto Order Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Ucargo.Order
  alias Ucargo.Repo

  schema "orders" do
    field :favourite, :boolean
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
    belongs_to :planning, Ucargo.Planning
    has_one :pickup, Ucargo.Pickup
    has_one :delivery, Ucargo.Delivery
    many_to_many :drivers, Ucargo.Driver, join_through: "available_orders"
    many_to_many :assigned_drivers, Ucargo.Driver,
                           join_through: "assigned_orders",
                           join_keys: [order_id: :id, driver_id: :id]
    timestamps()
  end

  def create_changeset(%Order{} = order, attrs) do
    order
      |> cast(attrs, [:favourite, :score, :deadline, :status, :type, :distance, :merchandise_type, :order_number, :transport, :weight, :comments, :driver_id])
      |> validate_required([:deadline])
      |> assoc_constraint(:driver)
  end

  def find_all do
    query = from o in Order,
            preload: [:pickup, :delivery]
    Repo.all(query)
  end
end
