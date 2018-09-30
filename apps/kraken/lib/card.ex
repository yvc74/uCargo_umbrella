defmodule Kraken.Card do
  @moduledoc """
  Module for made charges to a credit card
  """
  require Logger

  def charge(payment) do
    response = perform_charge_request(payment)
    case HTTPotion.Response.success?(response) do
      true ->
        response.body
        {:ok, ""}
      false ->
        Logger.info("inspect #{response.body}")
        #{:error, "Error in request from open pay"}
        {:ok, ""}
    end
  end

  defp perform_charge_request(payment) do
    headers = ["Content-Type": "application/json",
               "Authorization": "Basic c2tfMzE4NTg5NzE3YWE5NGUzY2FmYzc4ZTFmMTBlMjNhZTA6"]
    body = payment_body(payment)
    HTTPotion.post(
      "https://sandbox-api.openpay.mx/v1/ml5gfxvc4swuurvsdqdk/charges",
      body: Jason.encode!(body),
      headers: headers,
      timeout: 10_000
    )
  end

  defp payment_body(payment) do
    %{source_id: payment.source_id,
      method: payment.method,
      amount: payment.amount,
      currency: payment.currency,
      description: payment.description,
      order_id: payment.order_id,
      device_session_id: payment.device_session_id,
      customer: %{name: payment.name, email: payment.email}}
  end

end
