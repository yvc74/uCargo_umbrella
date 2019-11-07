defmodule Salomon.Application do
  @moduledoc """
  The Salomon Application Service.

  The Salomon system business domain lives in this application.

  Exposes API to clients such as the `UcargoWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Salomon.Repo, []),
    ], strategy: :one_for_one, name: Salomon.Supervisor)
  end
end
