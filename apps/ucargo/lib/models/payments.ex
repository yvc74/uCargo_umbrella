defmodule Ucargo.Payments do
  @moduledoc """
  Module for create payments
  """
  def order(payment_form) do
    payment = %Kraken.OpenPay{source_id: payment_form.source_id,
                       amount: payment_form.amount,
                     order_id: payment_form.order_id,
            device_session_id: payment_form.device_session_id,
                         name: payment_form.name,
                        email: payment_form.email}
    Kraken.Card.charge(payment)
  end
end