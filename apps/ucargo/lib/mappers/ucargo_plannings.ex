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
            preload: [order: [:pickup, :delivery]]
    Repo.all(query)
  end
end
