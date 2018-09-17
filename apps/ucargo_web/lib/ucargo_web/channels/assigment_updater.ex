defmodule UcargoWeb.Updater do
  @moduledoc """
  Module for receive updates from bank
  """
  use GenServer
  alias UcargoWeb.Endpoint, as: UpdaterSocket

  def start_link(name) do
    GenServer.start_link(__MODULE__, nil, [name: name])
  end

  def init(args) do
    {:ok, args}
  end

  def handle_call({:update, user_id, data}, _from, state) do
    UpdaterSocket.broadcast("assigment:" <> user_id, "updateOrderStatus", %{body: data})
    {:reply, :ok, state}
  end

  def send_event(broker_id, event) do
    UpdaterSocket.broadcast("assigment:" <> "#{broker_id}", "updateOrderStatus", %{body: render_event(event)})
  end


  def render_event(event) do
    %{
      date: event.date,
      id: event.id,
      latitude: event.latitude,
      longitude: event.longitude,
      name: event.name,
      picture: event.picture,
      price: event.price
    }
  end
end
