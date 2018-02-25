defmodule UcargoWeb.WebSessionController do
  use UcargoWeb, :controller
  plug :put_layout, "SigninLayout.html"

  def signup(conn, _params) do
    render conn, "index.html"
  end

  def signin(conn, _params) do
    render conn, "signin.html"
  end
end
