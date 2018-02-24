defmodule Ucargo.Planning do
  @moduledoc """
  Ecto Planings Mapper
  """
  use Ecto.Schema

  schema "plannings" do
    belongs_to :custom_broker, Ucargo.CustomBroker
    belongs_to :order, Ucargo.Order
  end
end
