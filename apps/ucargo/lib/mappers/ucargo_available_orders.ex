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

  def validate_available_order(driver_id, order_id) do
    case find_by(driver_id, order_id) do
      nil ->
        {:error, "Order with id: #{order_id} its not avalable for driver with id #{driver_id}"}
      avalaible_order ->
        {:ok, avalaible_order}
    end
  end

  def find_by(driver_id, order_id) do
    query = from a in AvailableOrder,
            where: a.driver_id == ^driver_id and a.order_id == ^order_id,
            preload: [:bid, [order: [:pickup, [available_order: :bid], :delivery, :custom, [planning: [:custom_broker, auction: [:bids]]]]], :driver]
    Repo.one(query)
  end

  def find_new(driver_id) do
    query = from a in AvailableOrder,
            where: a.driver_id == ^driver_id and a.status == "New",
            preload: [:bid, [order: [:pickup, [available_order: :bid], :delivery, :custom, [planning: [:custom_broker, auction: [:bids]]]]]]
    Repo.all(query)
  end

  def find_approved(driver_id) do
    query = from a in AvailableOrder,
            where: a.driver_id == ^driver_id and a.status != "New" and a.status != "Signed" and a.status != "Finished",
            preload: [:bid, [order: [:pickup, [available_order: :bid], :delivery, :custom, [planning: [:custom_broker, auction: [:bids]]]]]]
    Repo.all(query)
  end

  def find_completed_by(driver_id) do
    query = from a in AvailableOrder,
            where: a.driver_id == ^driver_id and a.status == "Signed" or a.status == "Finished",
            preload: [:bid, [order: [:pickup, [available_order: :bid], :delivery, :custom, [planning: [:custom_broker, auction: [:bids]]]]]]
    Repo.all(query)
  end

  def find_by(driver_id) do
    query = from a in AvailableOrder,
            where: a.driver_id == ^driver_id,
            preload: [:bid, [order: [:pickup, [available_order: :bid], :delivery, :custom, [planning: [:custom_broker, auction: [:bids]]]]]]
    Repo.all(query)
  end

  def update_changeset(%AvailableOrder{} = available_order, attrs) do
    available_order
      |> cast(attrs, [:bid_id, :status])
      |> assoc_constraint(:bid)
  end

  def update(changeset) do
    Repo.update!(changeset)
  end

end