use Mix.Config

# Configure your database
config :salomon, Salomon.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "salomon_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
