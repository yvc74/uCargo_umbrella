use Mix.Config

config :ucargo, Ucargo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "ucargo_prod",
  pool_size: 15
