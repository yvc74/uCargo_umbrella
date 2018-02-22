defmodule Ucargo.CustomBrokers do
    @moduledoc """
    Ecto CustomBrokers Mapper
    """
    use Ecto.Schema
  
    schema "custom_brokers" do
      field :name, :string
      has_many :favourite_drivers, Ucargo.FavouriteDrivers
      has_many :planings, Ucargo.Planings
    end
  
  end
  