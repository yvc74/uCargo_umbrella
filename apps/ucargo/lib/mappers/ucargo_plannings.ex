defmodule Ucargo.Planning do
  @moduledoc """
  Ecto Planings Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Ucargo.Planning
  alias Ucargo.Repo
  alias Ucargo.Auction
  alias Ucargo.Bid

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
    date_now = NaiveDateTime.utc_now()
    auction_chgs = Auction.create_changeset(%Auction{},
                   %{begin_date: date_now,
                     end_date: NaiveDateTime.add(date_now, 86400, :second),
                     ask_price: 10500.45})

    bid_chgs = Bid.create_changeset(%Bid{}, %{price: 324443, winner: true})
    auction_with_bids = Ecto.Changeset.put_assoc(auction_chgs, :bids, [bid_chgs])

    auction = Repo.insert! auction_with_bids
    
    pl_with_order = Ecto.Changeset.put_assoc(pl_changeset, :order, order)
    pl_with_auction = Ecto.Changeset.put_assoc(pl_with_order, :auction, auction)
    
    Repo.insert! pl_with_auction
  end
end
