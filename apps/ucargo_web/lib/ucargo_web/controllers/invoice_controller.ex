defmodule UcargoWeb.InvoiceController do
  use UcargoWeb, :controller
  alias Ucargo.Order
  alias Ucargo.Guardian
  alias Ucargo.CustomBroker
  alias Ucargo.Driver

  alias Ucargo.Order

  def index(conn, %{"order_id" => order_id, "driver_id" => driver_id}) do
    order = Order.find_by(:id, order_id)
    resource = Guardian.Plug.current_resource(conn)
    driver = Driver.find_by(:id, driver_id)
    render conn, "index.html", order: order, custom_broker: resource,
                               planning: order.planning, driver: driver, section_name: "records"
  end

  def download_xml(conn, %{"order_id" => order_id}) do
    order = Order.find_by(:id, order_id)
    uuid = UUID.uuid4()
    File.write!("/tmp/#{uuid}_invoice.xml", order.invoice_xml)
    conn
      |> put_resp_header("content-disposition",
                       ~s(attachment; filename="invoice.xml"))
      |> send_file(200, "/tmp/invoice.xml")
  end

  def download_pdf(conn, %{"order_id" => order_id}) do
    order = Order.find_by(:id, order_id)
    uuid = UUID.uuid4()
    File.write!("/tmp/#{uuid}_invoice.pdf", order.invoice_pdf)
    conn
      |> put_resp_header("content-disposition",
                       ~s(attachment; filename="invoice.pdf"))
      |> send_file(200, "/tmp/#{uuid}_invoice.pdf")


end
