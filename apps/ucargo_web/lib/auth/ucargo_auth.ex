defmodule UcargoWeb.Guardian do
  @moduledoc """
  Guardian Module
  """
  use Guardian, otp_app: :ucargo_web
  alias Ucargo.CustomBroker
  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def resource_from_claims(claims) do
    driver_id = claims["sub"]
    CustomBroker.get_by_id(driver_id)
  end
end
