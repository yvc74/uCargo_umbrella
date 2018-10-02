defmodule UcargoWeb.InvoiceController do
  use UcargoWeb, :controller

  alias Ucargo.Order

  def index(conn, %{"order_id" => order_id}) do
    order = Order.find_by(:id, order_id)
    render conn, "index.html", section_name: "records", order: order
  end

  def download_xml(conn, %{"order_id" => order_id}) do
    order = Order.find_by(:id, order_id)
    invoice = File.write!("/tmp/invoice.xml", order.invoice_xml)
    conn
      |> put_resp_header("content-disposition",
                       ~s(attachment; filename="invoice.xml"))
      |> send_file(200, "/tmp/invoice.xml")
  end

  def download_pdf(conn, %{"order_id" => order_id}) do
    order = Order.find_by(:id, order_id)
    invoice = File.write!("/tmp/invoice.pdf", order.invoice_pdf)
    conn
      |> put_resp_header("content-disposition",
                       ~s(attachment; filename="invoice.pdf"))
      |> send_file(200, "/tmp/invoice.pdf")
  end

end
