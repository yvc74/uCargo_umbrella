defmodule Ucargo.FavouriteDrivers do
    @moduledoc """
    Ecto FavouriteDrivers Mapper
    """
    use Ecto.Schema
  
    schema "favourite_drivers" do
      belongs_to :drivers, Ucargo.Driver
      belongs_to :custom_brokers, Ucargo.CustomBrokers
    end
  
  end
  