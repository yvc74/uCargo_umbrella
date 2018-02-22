defmodule Ucargo.Planings do
    @moduledoc """
    Ecto Planings Mapper
    """
    use Ecto.Schema
  
    schema "planings" do
      belongs_to :custom_brokers, Ucargo.CustomBrokers
      belongs_to :order, Ucargo.Order
    end
  
  end
  