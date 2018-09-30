defmodule Ucargo.Payments do
  @moduledoc """
  Module for create payments
  """
  alias Ucargo.Order
  alias Ucargo.Planning
  alias Ucargo.Bid

  def order(payment_form) do
    payment = %Kraken.OpenPay{source_id: payment_form.source_id,
                       amount: payment_form.amount,
                     order_id: payment_form.order_id,
            device_session_id: payment_form.device_session_id,
                         name: payment_form.name,
                        email: payment_form.email}

    with {:ok, _} <- Kraken.Card.charge(payment),
         {:ok, %{"DocumentoId" => document_id}} <- Kraken.Invoice.generate(payment),
         {:ok, %{"Bytes" => xml_base64}} <- Kraken.Invoice.download_xml(document_id),
         {:ok, %{"Bytes" => pdf_base64}} <- Kraken.Invoice.download_pdf(document_id) do

      order = Order.find_by(:id, payment_form.ucargo_order_id)
      changeset = Order.update_changeset(order, %{invoice_xml: Base.decode64!(xml_base64),
                                                  invoice_pdf: Base.decode64!(pdf_base64)})
      if changeset.valid? do
        Order.update(changeset)
        create_assigment(payment_form.planning_id, payment_form.bid_id)
      else
        changeset.errors
      end
    else
      {:error, error} ->
        {:error, error}
      err ->
        err
    end
  end

  def create_assigment(planning_id, bid_id) do
    planning = Planning.find_by(:id, planning_id)
    bid = Bid.find_by(:id, bid_id)
    Planning.mark_as_winner(planning)
    Bid.mark_as_winner(bid)
    Order.create_assignment(planning.order, bid.driver)
  end
end