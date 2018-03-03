defmodule Ucargo.Auction do
  @moduledoc """
  Ecto Auction Mapper
  """
  use Ecto.Schema

  schema "acutions" do
    field :begin_date, :naive_datetime
    field :end_date, :naive_datetime
    belongs_to :planning, Ucargo.Planning
    has_many :bids, Ucargo.Bid
  end
end
