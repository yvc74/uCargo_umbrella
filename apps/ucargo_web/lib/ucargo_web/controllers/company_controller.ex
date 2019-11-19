defmodule UcargoWeb.CompanyController do
  use UcargoWeb, :controller
  alias Ucargo.CustomBroker
  plug :put_layout, "SigninLayout.html"

  def index(conn, _params) do
    changeset = CustomBroker.create_changeset(%CustomBroker{}, %{})
    render conn, "signin.html", changeset: changeset,
                            session_error: false,
                             company_name: conn.private[:subdomain]
  end

end