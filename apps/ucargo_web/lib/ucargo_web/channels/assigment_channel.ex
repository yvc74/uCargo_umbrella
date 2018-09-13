defmodule UcargoWeb.AssigmentChannel do
  @moduledoc """
  Channel for handling assigment change events
  """
  use Phoenix.Channel

  def join("assigment:" <> _user_id, _message, socket) do
    {:ok, socket}
  end

  def join("assigment:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  # def handle_in("update_state_combo", %{"body" => state_id}, socket) do
  #   cities = Ucargo.City.find(state_id)
  #   {:reply, {:ok, %{data: cities}}, socket}
  # end

  # def handle_in("update_city_combo", %{"body" => city_id}, socket) do
  #   neighborhoods = Ucargo.Neighborhood.find(city_id)
  #   {:reply, {:ok, %{data: neighborhoods}}, socket}
  # end

  def handle_out(_, payload, socket) do
    push socket, "", payload
    {:noreply, socket}
  end
end
