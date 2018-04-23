defmodule UcargoWeb.FavouriteDriverController do
  use UcargoWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def profile(conn, _params) do
     render conn, "profile.html"
  end
end
