defmodule Ucargo.Bid do
  @moduledoc """
  Ecto Auction Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Ucargo.Bid

  schema "bids" do
    field :price, :decimal
    field :winner, :boolean
    belongs_to :auction, Ucargo.Auction
  end
  
  def create_changeset(%Bid{} = bid, attrs) do
    bid
      |> cast(attrs, [:price, :winner, :auction_id])
      |> assoc_constraint(:auction)
  end
end
