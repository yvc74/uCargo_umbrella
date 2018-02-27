defmodule Ucargo.Planning do
  @moduledoc """
  Ecto Planings Mapper
  """
  use Ecto.Schema

  schema "plannings" do
    belongs_to :custom_broker, Ucargo.CustomBroker
    has_one :order, Ucargo.Order
    has_one :auction, Ucargo.Auction
  end
end
