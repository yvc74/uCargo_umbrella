defmodule Ucargo.Planning do
  @moduledoc """
  Ecto Planings Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Ucargo.Planning
  alias Ucargo.Repo

  schema "plannings" do
    belongs_to :custom_broker, Ucargo.CustomBroker
    has_one :order, Ucargo.Order
    has_one :auction, Ucargo.Auction
  end

  def create_changeset(planning, attrs) do
    planning
      |> cast(attrs, [:custom_broker_id])
      |> assoc_constraint(:custom_broker)
  end

  def find_all do
    query = from p in Planning,
            preload: [auction: [:bids], order: [:pickup, :delivery]]
    Repo.all(query)
  end

  def create_with_order(order_chs, pick_chgset, deliver_chgset) do
    order_with_pick = Ecto.Changeset.put_assoc(order_chs, :pickup, pick_chgset)
    order_with_delivery = Ecto.Changeset.put_assoc(order_with_pick, :delivery, deliver_chgset)
    order = Repo.insert! order_with_delivery
    pl_changeset = Planning.create_changeset(%Planning{}, %{})
    pl_with_order = Ecto.Changeset.put_assoc(pl_changeset, :order, order)
    Repo.insert! pl_with_order
  end
end
