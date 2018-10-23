defmodule Ucargo.Share do
  @moduledoc """
  Module for share orders status
  """
  alias Ucargo.Order
  alias Ucargo.CustomBroker
  alias Kraken.Mail
  alias Kraken.Mailer

  def share_on_route_to_custom(mails, user_id, send_to_self, _order_id) do
    #order = Order.find_by(:id, order_id)
    email_list = String.split(mails, ",")
    if send_to_self do
      {:ok, broker} = CustomBroker.get_by_id(user_id)
      broker_email = broker.email
      mail = Mail.share_status(email_list ++ [broker_email], "Tu cargamento va rumbo a la aduana")
      Mailer.deliver_later(mail)
    else
      mail = Mail.share_status(email_list, "Tu cargamento va rumbo a la aduana")
      Mailer.deliver_later(mail)
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