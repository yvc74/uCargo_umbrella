defmodule Ucargo.Delivery do
    @moduledoc """
    Ecto Delivery Mapper
    """
    use Ecto.Schema
  
    schema "delivery" do
      field :latitude, :string
      field :longitude, :string
      field :name, :string
      field :address, :string
      field :schedule, :string
      belongs_to :order, Ucargo.Order
      timestamps()
    end
  
  end
  