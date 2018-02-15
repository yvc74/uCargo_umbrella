defmodule Ucargo.Pickup do
    @moduledoc """
    Ecto Pickup Mapper
    """
    use Ecto.Schema
  
    schema "pickup" do
      field :latitude, :string
      field :longitude, :string
      field :name, :string
      field :address, :string
      field :schedule, :string
      belongs_to :order, Ucargo.Order
      timestamps()
    end
  
  end
  