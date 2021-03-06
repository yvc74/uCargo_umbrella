defmodule Ucargo.Auction do
  @moduledoc """
  Ecto Auction Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Ucargo.Auction
  alias Ucargo.Repo

  schema "auctions" do
    field :begin_date, :naive_datetime
    field :end_date, :naive_datetime
    field :ask_price, :decimal
    belongs_to :planning, Ucargo.Planning
    has_many :bids, Ucargo.Bid
  end

  def create_changeset(%Auction{} = auction, attrs) do
    auction
      |> cast(attrs, [:begin_date, :end_date, :ask_price])
  end

  def update_changeset(%Auction{} = auction, attrs) do
    auction
      |> cast(attrs, [])
  end

  def update(changeset) do
    Repo.update!(changeset)
  end
end
