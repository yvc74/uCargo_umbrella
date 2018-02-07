defmodule UcargoWeb.SessionView do
  use UcargoWeb, :view

  def render("driver.json", %{user: driver, token: token}) do
    %{
      account: %{
        name: driver.name,
        email: driver.email,
        picture: driver.picture,
        token: token
      }
    }
  end
end
