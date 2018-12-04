defmodule UcargoWeb.AddressChannel do
  @moduledoc """
  Channel for handling select change events
  """
  use Phoenix.Channel

  def join("address:creation", _message, socket) do
    {:ok, socket}
  end

  def join("address:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("geocode_address", %{"body" => address}, socket) do
    location = Ucargo.Map.geocode_address(address)
    {:reply, {:ok, %{data: location}}, socket}
  end

end