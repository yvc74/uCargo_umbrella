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

  pipeline :login do
    plug UcargoWeb.BasicHeadersValidation
    plug Ucargo.BasicAuth
  end

  scope "/", UcargoWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", UcargoWeb do
    pipe_through :api
    scope "/drivers" do
      scope "/" do
        post "/account", SessionController, :signup
      end

      scope "/" do
        pipe_through :login
        get "/account", SessionController, :signin
      end

      scope "/" do
        pipe_through :authorized
        get "/settings", SettingsController, :settings
        get "/orders", DriverController, :orders
        patch "/account", DriverController, :update
      end

    end
  end
end
