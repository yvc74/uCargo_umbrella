defmodule UcargoWeb.IntroController do
  use UcargoWeb, :controller

  plug :put_layout, "IntroLayout.html"

  def index(conn, _params) do
    render conn, "index.html"
  end

  def about(conn, _params) do
    render conn, "about.html"
  end

  def customs(conn, _params) do
    render conn, "customs.html"
  end

  def transporters(conn, _params) do
    render conn, "transporters.html"
  end

  def faq(conn, _params) do
    render conn, "faq.html"
  end

end
