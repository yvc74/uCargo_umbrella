defmodule UcargoWeb.FavouriteDriverController do
  use UcargoWeb, :controller
  alias Ucargo.Driver
  alias Ucargo.Guardian
  alias Ucargo.CustomBroker

  def index(conn, _params) do
    resource = Guardian.Plug.current_resource(conn)
    custom_broker = CustomBroker.fetch_favourite_drivers(resource)
    custom_broker_drivers = List.first(custom_broker)
    render conn, "index.html", drivers: custom_broker_drivers.drivers, section_name: "favourites"
  end

  def profile(conn, %{"driver_id" => driver_id}) do
    driver = Driver.find_by(:id, driver_id)
    render conn, "profile.html",  driver: driver, section_name: "favourites"
  end
end
