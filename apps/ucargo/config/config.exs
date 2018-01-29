use Mix.Config

config :ucargo, ecto_repos: [Ucargo.Repo]

config :ucargo, Ucargo.Guardian,
  issuer: "ucargo",
  secret_key: "/SYNjtAF0/dajy8dwXKc37hTYqUwHlWOHrhUE8MteA3Ru49jb7j4Rh6W2XPsdPWD"

import_config "#{Mix.env}.exs"
