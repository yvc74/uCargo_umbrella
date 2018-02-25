defmodule UcargoWeb.ShipController do
  use UcargoWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, _params) do
    render conn, "create.html"
  end

end
