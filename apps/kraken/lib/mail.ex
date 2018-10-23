defmodule Kraken.Mail do
  @moduledoc """
  Module for compose mails
  """
  import Bamboo.Email

  def new_planning_avalaible(mail_list) do
    new_email()
      |> to(mail_list)
      |> from("ucargo.service@ucargo.com")
      |> subject("Nuevo Cargamento disponible")
      |> html_body("<strong>Welcome</strong>")
      |> text_body("Esta disponble un nuevo cargamento para ti")
  end

  def share_status(mail_list, message) do
    new_email()
      |> to(mail_list)
      |> from("ucargo.service@ucargo.com")
      |> subject("Reporte de status del cargamento")
      |> html_body("<strong>#{message}</strong>")
  end

  def share_invoice(mail_list, message, invoice_xml, invoice_pdf) do
    new_email()
      |> to(mail_list)
      |> from("ucargo.service@ucargo.com")
      |> subject("Pago UCargo")
      |> put_attachment(%Bamboo.Attachment{filename: "invoice.xml", data: invoice_xml})
      |> put_attachment(%Bamboo.Attachment{filename: "invoice.pdf", data: invoice_pdf})
      |> html_body("<strong>#{message}</strong>")
  end

end
