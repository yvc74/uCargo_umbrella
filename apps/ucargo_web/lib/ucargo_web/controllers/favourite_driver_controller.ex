defmodule UcargoWeb.FavouriteDriverController do
  use UcargoWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", section_name: "favourites"
  end

  def profile(conn, _params) do
    render conn, "profile.html", section_name: "favourites"
  end
end
