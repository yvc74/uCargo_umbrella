defmodule Ucargo.AvailableOrder do
  @moduledoc """
  Ecto AvailableOrders Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Ucargo.AvailableOrder
  alias Ucargo.Repo

  schema "available_orders" do
    field :status, :string
    belongs_to :driver, Ucargo.Driver
    belongs_to :order, Ucargo.Order
    belongs_to :bid, Ucargo.Bid
  end

  def find_by(driver_id, order_id) do
    query = from a in AvailableOrder,
            where: a.driver_id == ^driver_id and a.order_id == ^order_id,
            preload: [:bid, :order, :driver]
    Repo.one(query)
  end

  def find_by(driver_id) do
    query = from a in AvailableOrder,
            where: a.driver_id == ^driver_id,
            preload: [:bid, [order: [:pickup, [available_order: :bid], :delivery, :custom, [planning: [:custom_broker, auction: [:bids]]]]]]
    Repo.all(query)
  end

  def update_changeset(%AvailableOrder{} = available_order, attrs) do
    available_order
      |> cast(attrs, [:bid_id])
      |> assoc_constraint(:bid)
  end

end