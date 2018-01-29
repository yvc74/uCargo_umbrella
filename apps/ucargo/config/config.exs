use Mix.Config

config :ucargo, ecto_repos: [Ucargo.Repo]

import_config "#{Mix.env}.exs"
