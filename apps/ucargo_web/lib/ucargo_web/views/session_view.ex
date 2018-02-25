defmodule UcargoWeb.SessionView do
  use UcargoWeb, :view

  def render("driver.json", %{user: driver, token: token}) do
    %{
      account: %{
        name: driver.name,
        username: driver.username,
        email: driver.email,
        picture: driver.picture,
        token: token,
        phone: driver.phone,
        score: driver.score
      }
    }
  end
end
