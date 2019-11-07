use Mix.Config

config :salomon, ecto_repos: [Salomon.Repo]

import_config "#{Mix.env}.exs"
