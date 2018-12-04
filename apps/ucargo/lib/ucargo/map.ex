defmodule Ucargo.Map do
  @moduledoc """
  Module for working with maps
  """
  alias Kraken.Geocoding

  def geocode_address(address) do
    case Geocoding.get_geocoding(address) do
      {:ok, location} ->
        location
      _ ->
        %{lat: 19.4326018, long: -99.1353989}
    end
  end
end