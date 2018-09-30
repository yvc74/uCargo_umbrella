defmodule Ucargo.Order do
  @moduledoc """
  Ecto Order Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Ucargo.Order
  alias Ucargo.Repo
  alias Ucargo.Driver

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
    field :custom_light_picture, :string
    field :lock_picture, :string
    field :deliver_picture, :string
    field :invoice_xml, :string
    field :invoice_pdf, :binary
    belongs_to :planning, Ucargo.Planning
    has_one :pickup, Ucargo.Pickup
    has_one :delivery, Ucargo.Delivery
    has_one :custom, Ucargo.Custom
    has_one :available_order, Ucargo.AvailableOrder
    many_to_many :drivers, Ucargo.Driver, join_through: Ucargo.AvailableOrder
    many_to_many :assigned_drivers, Ucargo.Driver,
                           join_through: "assigned_orders",
                           join_keys: [order_id: :id, driver_id: :id]
    timestamps()
  end

  def create_changeset(%Order{} = order, attrs) do
    order
      |> cast(attrs, [:favourite, :score, :custom_light_picture, :lock_picture, :deliver_picture, :deadline, :status, :type, :distance, :merchandise_type, :order_number, :transport, :weight, :comments])
      |> validate_required([:deadline])
  end

  def update_changeset(%Order{} = order, attrs) do
    order
      |> cast(attrs, [:favourite, :score, :custom_light_picture, :lock_picture, :deliver_picture, :deadline, :status, :type, :distance, :merchandise_type, :order_number, :transport, :weight, :comments, :invoice_xml, :invoice_pdf])
  end

  def update(changeset) do
    Repo.update!(changeset)
  end

  def find_all do
    query = from o in Order,
            preload: [:pickup, :delivery, :custom]
    Repo.all(query)
  end

  def find_assigned(driver) do
    driver = Repo.preload(driver, [orders: [:pickup, [available_order: :bid], :delivery, :custom, [planning: [:custom_broker, auction: [:bids]]]]])
    driver
  end

  def find_by(:id, order_id) do
    query = from o in Order,
            where: o.id == ^order_id,
            preload: [:pickup, :delivery, :custom, [planning: [auction: [:bids]]]]
    Repo.one(query)
  end

  def validate_order_id(order_id) do
    case Order.find_by(:id, order_id) do
      nil ->
        {:error, "Order with number #{order_id} not found"}
      order ->
        {:ok, order}
    end
  end

  def create_assignment(order, driver) do
    current_driver = driver
    driver = Driver.update_changeset(driver, %{})
    order_with_drivers =
    order
      |> Repo.preload(:assigned_drivers)
      |> Repo.preload(:drivers)
      |> Repo.preload(:planning)
    order_chs = Order.update_changeset(order_with_drivers, %{status: "Approved"})
    avl_order =  Ucargo.AvailableOrder.find_by(current_driver.id, order_with_drivers.id)
    chg_set = Ucargo.AvailableOrder.update_changeset(avl_order,  %{status: "Approved"})
    Ucargo.AvailableOrder.update(chg_set)
    driver_with_orders = Ecto.Changeset.put_assoc(order_chs, :assigned_drivers, [driver])
    Repo.update!(driver_with_orders)
  end

  def fetch_assigned_items(plannings) do
    Enum.flat_map(plannings, fn(planning) ->
      order = Repo.preload(planning.order, :assigned_drivers)
      case order.assigned_drivers do
        [] ->
          []
        drivers ->
          build_item(drivers, order, planning)
      end
    end)
  end

  defp build_item(drivers, order, planning) do
    Enum.map(drivers, fn(driver) ->
      %{driver: driver, order: order, planning: planning}
    end)
  end
end
