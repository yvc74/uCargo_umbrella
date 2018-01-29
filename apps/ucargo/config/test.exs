use Mix.Config

# Configure your database
config :ucargo, Ucargo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "ucargo_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
