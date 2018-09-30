defmodule UcargoWeb.PaymentChannel do
  @moduledoc """
  Channel for handling assigment change events
  """
  use Phoenix.Channel

  def join("payment:charge", _message, socket) do
    {:ok, socket}
  end

  def handle_in("apply_charge", %{"body" => payment_body}, socket) do
    form_data = %{source_id: payment_body["token"],
                     amount: payment_body["amount"],
            ucargo_order_id: payment_body["ucargoOrderId"],
                planning_id: payment_body["planningId"],
                     bid_id: payment_body["bidId"],
                   order_id: UUID.uuid4(),
          device_session_id: payment_body["deviceSessionId"],
                       name: payment_body["name"],
                      email: payment_body["email"]}
    Ucargo.Payments.order(form_data)
    {:reply, {:ok, %{}}, socket}
  end

  def handle_out(_, payload, socket) do
    push socket, "", payload
    {:noreply, socket}
  end
end
