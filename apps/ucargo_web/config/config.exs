# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ucargo_web,
  namespace: UcargoWeb,
  ecto_repos: [Ucargo.Repo]

config :ucargo_web, :phoenix_swagger,  
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: UcargoWeb.Router,     # phoenix routes will be converted to swagger paths
      endpoint: UcargoWeb.Endpoint  # (optional) endpoint config used to set host, port and https schemes.
    ]
  }

# Configures the endpoint
config :ucargo_web, UcargoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mDPimYNKkiJtoPVj59fcNlJ/6K6q4E029j4SwxqQeqrc+Lhg9FZ3ZW7g+CxWvXNd",
  render_errors: [view: UcargoWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: UcargoWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ucargo_web, :generators,
  context_app: :ucargo

    
  

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
