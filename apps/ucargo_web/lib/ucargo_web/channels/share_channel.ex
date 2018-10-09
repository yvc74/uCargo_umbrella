defmodule UcargoWeb.ShareChannel do
  @moduledoc """
  Channel for handling share events
  """
  use Phoenix.Channel

  alias Ucargo.Share

  def join("share:status", _message, socket) do
    {:ok, socket}
  end

  def handle_in("shareOnRouteToCustom", %{"body" => share_body}, socket) do
    IO.inspect Share.share_on_route_to_custom(share_body["emails"],
                                   share_body["userId"],
                                   share_body["sendToMe"],
                                   share_body["orderId"])
    {:reply, {:ok, %{}}, socket}
  end
end

# %{
#   "emails" => "misa@misa.com",
#   "orderId" => "1",
#   "sendToMe" => true,
#   "userId" => "1"
# }