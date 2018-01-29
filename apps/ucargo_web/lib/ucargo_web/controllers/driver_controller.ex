defmodule UcargoWeb.DriverController do
  @moduledoc """
  Controller for drivers
  """
  use UcargoWeb, :controller

  def show(conn, _params) do
    driver = conn.assigns[:driver]
    conn
      |> put_status(200)
      |> json(%{driver: %{username: driver.username, email: driver.email}})
  end
end
