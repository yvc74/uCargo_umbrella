defmodule Ucargo.Application do
  @moduledoc """
  The Ucargo Application Service.

  The ucargo system business domain lives in this application.

  Exposes API to clients such as the `UcargoWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Ucargo.Repo, []),
    ], strategy: :one_for_one, name: Ucargo.Supervisor)
  end
end
