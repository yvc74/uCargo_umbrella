defmodule UcargoWeb.ShipController do
  use UcargoWeb, :controller
  alias Ucargo.Planning

  def index(conn, _params) do
    plannings = Planning.find_all
    render conn, "index.html", plannings: plannings
  end

  def create(conn, _params) do
    render conn, "create.html"
  end

end
