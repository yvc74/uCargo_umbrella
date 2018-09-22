defmodule UcargoWeb.PaymentChannel do
  @moduledoc """
  Channel for handling assigment change events
  """
  use Phoenix.Channel

  def join("payment:charge", _message, socket) do
    {:ok, socket}
  end

  def handle_in("apply_charge", %{"body" => payment_body}, socket) do
    IO.inspect payment_body
    {:reply, {:ok, %{}}, socket}
  end

  def handle_out(_, payload, socket) do
    push socket, "", payload
    {:noreply, socket}
  end
end
