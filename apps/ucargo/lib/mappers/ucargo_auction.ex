defmodule Ucargo.Auction do
  @moduledoc """
  Ecto Auction Mapper
  """
  use Ecto.Schema

  schema "acutions" do
    belongs_to :planning, Ucargo.Planning
    has_many :bids, Ucargo.Bid
  end
end
