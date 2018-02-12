defmodule UcargoWeb.SettingsController do
  use UcargoWeb, :controller
  use PhoenixSwagger
  alias Ucargo.CommonParameters
  	
  def swagger_definitions do
    %{
      Settings: swagger_schema do
        title "Settings"
        description "Driver's Settings"
        properties do
          help_number :string, "Help number"          
        end
        example %{
          help_number: "01800822746932"          
        }
      end      
    }
  end

  swagger_path(:settings) do
    get "/api/v1/driver/settings"
    summary "Driver's Settings"
    description "Obtaing a help number for Driver"
    produces "application/json"
    CommonParameters.authorization
    response 200, "OK", Schema.ref(:Settings), example: %{
      help_number: "01800822746932"
    }
  end

  def settings(conn, _params) do
    conn
      |> put_status(200)
      |> render("settings.json", %{help_number: "01800822746932"})
  end
  end  