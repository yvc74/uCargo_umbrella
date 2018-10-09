defmodule Ucargo.Share do
  @moduledoc """
  Module for share orders status
  """
  #alias Ucargo.Order
  alias Ucargo.CustomBroker
  alias Kraken.Mail
  alias Kraken.Mailer

  def share_on_route_to_custom(mails, user_id, send_to_self, _order_id) do
    #order = Order.find_by(:id, order_id)
    email_list = String.split(mails, ",")
    if send_to_self do
      {:ok, broker} = CustomBroker.get_by_id(user_id)
      broker_email = broker.email
      Mail.share_status(email_list ++ [broker_email], "Tu cargamento va rumbo a la aduana")
        |> Mailer.deliver_later
    else
      Mail.share_status(email_list, "Tu cargamento va rumbo a la aduana")
        |> Mailer.deliver_later
    end
  end

end