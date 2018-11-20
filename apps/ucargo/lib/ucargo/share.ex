defmodule Ucargo.Share do
  @moduledoc """
  Module for share orders status
  """
  alias Ucargo.Order
  alias Ucargo.CustomBroker
  alias Kraken.Mail
  alias Kraken.Mailer

  def share_on_route_to_custom(mails, user_id, send_to_self, _order_id, stage) do
    #order = Order.find_by(:id, order_id)
    email_list = String.split(mails, ",")
    if send_to_self do
      {:ok, broker} = CustomBroker.get_by_id(user_id)
      broker_email = broker.email
      mail = Mail.share_status(email_list ++ [broker_email], compose_message(stage))
      Mailer.deliver_later(mail)
    else
      mail = Mail.share_status(email_list, compose_message(stage))
      Mailer.deliver_later(mail)
    end
  end

  defp compose_message(stage) do
    case stage do
      "roadToCustom" ->
        "Tu cargamento va rumbo a la aduana"
      "reportLight" ->
        "El cargamento obtuvo la luz verde en el semafóro de la aduana"
      "reportLock" ->
        "Se ha enviado la fotografía del candado del cargamento"
      "reportMerchStored" ->
        "La mercancía ha sido almacenada"
      "reportBeginRoute" ->
        "La mercancía empezo su recorrido a su destino"
      "reportArriving" ->
        "La mercancía ha llegado a su destino"
      "reportDeliver" ->
        "La mercancía ha sido resibida por el cliente"
    end
  end

  def share_invoice(mails, user_id, send_to_self, order_id) do
    order = Order.find_by(:id, order_id)
    email_list = String.split(mails, ",")
    if send_to_self do
      {:ok, broker} = CustomBroker.get_by_id(user_id)
      broker_email = broker.email
      mail = Mail.share_invoice(email_list ++ [broker_email], "Comprobante de Pago", order.invoice_xml, order.invoice_pdf)
      Mailer.deliver_later(mail)
    else
      mail = Mail.share_invoice(email_list, "Comprobante de Pago",  order.invoice_xml, order.invoice_pdf)
      Mailer.deliver_later(mail)
    end
  end

end