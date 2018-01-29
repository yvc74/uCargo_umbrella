defmodule UcargoWeb.Router do
  use UcargoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authorized do
    plug UcargoWeb.HeadersValidation
    plug Ucargo.Apiauth
  end

  scope "/", UcargoWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", UcargoWeb do
    pipe_through :api
    scope "/users" do
      scope "/" do
        post "/sign_in", SessionController, :sign_in
        post "/log_in", SessionController, :login
      end

      scope "/" do
        pipe_through :authorized
        get "/me", DriverController, :show
      end
    end
  end
end
