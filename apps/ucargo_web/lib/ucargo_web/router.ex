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

  pipeline :browser_session do
    plug Guardian.Plug.Pipeline, module: UcargoWeb.Guardian,
                             error_handler: UcargoWeb.WebAuthErrorHandler
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :require_login do
    plug Guardian.Plug.EnsureAuthenticated, handler: Ucargo.Guardian
  end

  pipeline :login do
    plug UcargoWeb.BasicHeadersValidation
    plug Ucargo.BasicAuth
  end

  scope "/", UcargoWeb do
    pipe_through :browser # Use the default browser stack
    resources "/users", UserController
    resources "/roles", RoleController
    get "/", IntroController, :index
    get "/signin", WebSessionController, :signin
    post "/login", WebSessionController, :login
  end

  scope "/", UcargoWeb do
    pipe_through :browser # Use the default browser stack
    pipe_through :browser_session
    pipe_through :require_login
    get "/plannings", ShipController, :index
    get "/plannings/:type/new", ShipController, :create
    get "/plannings/:id/proposals", ShipController, :proposal_index
    get "/plannings/:planning_id/bids/:bid_id", ShipController, :show
    post "/plannings/submit", ShipController, :new
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
        get "/orders", OrderController, :show
        patch "/account", DriverController, :update
        delete "/orders/:order_number", DriverController, :order_delete
        post "/orders/:order_number/quotes", DriverController, :order_quotes
        post "/orders/:order_number/fav",  DriverController, :order_favorite
        delete "/orders/:order_number/fav", DriverController, :order_favorite_delete
        get "/orders/onroute", DriverController, :order_onroute
        post "/orders/:order_numer/events", DriverController, :events
      end

    end
  end

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :ucargo_web, swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "ucargo_web"
      }
    }
  end

end
