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
end
