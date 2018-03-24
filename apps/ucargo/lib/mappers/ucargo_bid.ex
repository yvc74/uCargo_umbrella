defmodule Ucargo.Bid do
  @moduledoc """
  Ecto Auction Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Ucargo.Bid
  alias Ucargo.Repo

  schema "bids" do
    field :price, :decimal
    field :winner, :boolean
    belongs_to :driver, Ucargo.Driver
    belongs_to :auction, Ucargo.Auction
  end

  def create_changeset(%Bid{} = bid, attrs) do
    bid
      |> cast(attrs, [:price, :winner, :auction_id, :driver_id])
      |> assoc_constraint(:auction)
      |> assoc_constraint(:driver)
  end

  def find_by(:id, bid_id) do
    query = from b in Bid,
            where: b.id == ^bid_id,
            preload: :driver
    Repo.one(query)
  end
end
