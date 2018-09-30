defmodule UcargoWeb.InvoiceController do
  use UcargoWeb, :controller

  def index(conn, _params) do
    render conn, "index.html", section_name: "records"
  end

end
