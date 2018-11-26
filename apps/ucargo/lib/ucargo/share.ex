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

  defp compose_message("roadToCustom"), do: "Tu cargamento va rumbo a la aduana"

  defp compose_message("reportLight"), do: "El cargamento obtuvo la luz verde en el semafóro de la aduana"

  defp compose_message("reportLock"), do: "Se ha enviado la fotografía del candado del cargamento"

  defp compose_message("reportBeginRoute"), do: "La mercancía empezo su recorrido a su destino"

  defp compose_message("reportArriving"), do: "La mercancía ha llegado a su destino"

  defp compose_message("reportDeliver"), do: "La mercancía ha sido resibida por el cliente"

  defp compose_message("reportOnCustomRoute"), do: "La mercancía va en camino a la aduana"

  defp compose_message("reportOnCustomArrival"), do: "La mercancía ha llegado a la aduana"

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