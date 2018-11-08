defmodule UcargoWeb.WebSessionController do
  use UcargoWeb, :controller
  alias Ucargo.CustomBroker
  alias UcargoWeb.Guardian
  plug :put_layout, "SigninLayout.html"

  action_fallback UcargoWeb.SessionFallbackController

  def signup(conn, _params) do
    render conn, "index.html"
  end

  def login(conn, params) do
    changeset = CustomBroker.login_changeset(%CustomBroker{}, params["custom_broker"])
    if changeset.valid? do
      {:ok, broker} = CustomBroker.get_by_user_name(params["custom_broker"]["username"])
      conn
        |> Guardian.Plug.sign_in(broker)
        |> redirect(to: "/plannings")
    else
      changeset.errors
    end
  end

  def signin(conn, _params) do
    changeset = CustomBroker.create_changeset(%CustomBroker{}, %{})
    render conn, "signin.html", changeset: changeset, session_error: false
  end
end
