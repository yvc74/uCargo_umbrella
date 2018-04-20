defmodule UcargoWeb.RecordController do
  use UcargoWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

end
