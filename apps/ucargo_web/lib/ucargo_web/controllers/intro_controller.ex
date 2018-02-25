defmodule UcargoWeb.IntroController do
  use UcargoWeb, :controller

  plug :put_layout, "IntroLayout.html"

  def index(conn, params) do
    render conn, "index.html"
  end

end
