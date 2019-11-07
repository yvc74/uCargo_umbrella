use Mix.Config

config :salomon, Salomon.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "salomon_prod",
  pool_size: 15
