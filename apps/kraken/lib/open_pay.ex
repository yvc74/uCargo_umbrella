defmodule Kraken.OpenPay do
  @moduledoc """
  Module that represents open pay charge
  """
  defstruct source_id: "", method: "card", amount: 0,
            currency: "MXN", description: "Cargo por servicio de transportación",
            order_id: "", device_session_id: "", customer: %{}

end