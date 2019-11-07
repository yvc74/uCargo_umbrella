use Mix.Config

# Configure your database
config :salomon, Salomon.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "salomon_dev",
  hostname: "localhost",
  pool_size: 10