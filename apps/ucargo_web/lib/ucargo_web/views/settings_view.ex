defmodule UcargoWeb.SettingsView do
    use UcargoWeb, :view
  
    def render("settings.json", %{help_number: number}) do
        %{settings:
          %{
            help_number: number
          }
        }
    end
  end
  