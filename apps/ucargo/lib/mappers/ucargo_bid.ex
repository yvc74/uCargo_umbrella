defmodule Ucargo.Bid do
  @moduledoc """
  Ecto Auction Mapper
  """
  use Ecto.Schema

  schema "bids" do
    belongs_to :auction, Ucargo.Auction
  end
end
