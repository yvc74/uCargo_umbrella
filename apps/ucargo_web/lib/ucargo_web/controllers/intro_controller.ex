defmodule UcargoWeb.IntroController do
  use UcargoWeb, :controller

  def index(conn, params) do
    render conn, "index.html"
  end

end
