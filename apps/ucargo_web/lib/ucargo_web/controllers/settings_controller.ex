defmodule UcargoWeb.SettingsController do
  use UcargoWeb, :controller
  use PhoenixSwagger

  	swagger_path :settings do
  		get "/settings"
  		description "Settings driver"
  		response 200, "Success"
		end

    def settings(conn, _params) do
      conn
        |> put_status(200)
        |> render("settings.json", %{help_number: "01800822746932"})
    end
  end
  