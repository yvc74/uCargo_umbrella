defmodule Ucargo.Guardian do
  @moduledoc """
  Guardian Module
  """
  use Guardian, otp_app: :ucargo
  alias Ucargo.Driver
  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def resource_from_claims(claims) do
    driver_id = claims["sub"]
    Driver.get_by_id(driver_id)
  end
end