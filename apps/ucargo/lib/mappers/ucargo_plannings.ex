defmodule Ucargo.Planning do
  @moduledoc """
  Ecto Planings Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Ucargo.Planning
  alias Ucargo.Repo
  alias Ucargo.Driver
  alias Kraken.Mailer
  alias Kraken.Mail
  alias Ucargo.Auction
  alias Ucargo.Bid

  schema "plannings" do
    field :master_reference, :string
    field :house_reference, :string
    belongs_to :custom_broker, Ucargo.CustomBroker
    has_one :order, Ucargo.Order
    has_one :auction, Ucargo.Auction
  end

  def create_changeset(planning, attrs) do
    planning
      |> cast(attrs, [:master_reference, :house_reference, :custom_broker_id])
      |> assoc_constraint(:custom_broker)
  end

  def find_all do
    query = from p in Planning,
            preload: [auction: [:bids], order: [:pickup, :delivery, :custom]]
    Repo.all(query)
  end

  def find_by(:id, planning_id) do
    query = from p in Planning,
            where: p.id == ^planning_id,
            preload: [:custom_broker, auction: [:bids], order: [:pickup, :delivery, :custom]]
    Repo.one(query)
  end

  def create_with_order(order_chs, pick_chgset, deliver_chgset, broker_id) do
    order_with_pick = Ecto.Changeset.put_assoc(order_chs, :pickup, pick_chgset)
    order_with_delivery = Ecto.Changeset.put_assoc(order_with_pick, :delivery, deliver_chgset)
    order = Repo.insert! order_with_delivery
    notify_to_drivers(order)
    pl_changeset = Planning.create_changeset(%Planning{}, %{custom_broker_id: broker_id})
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

  def notify_to_drivers(_order) do
    driver_mails = Driver.fetch_all_mails
    driver_mails
      |> Mail.new_planning_avalaible
      |> Mailer.deliver_later
  end

  def notify_to__favourite_drivers do
  end
end
