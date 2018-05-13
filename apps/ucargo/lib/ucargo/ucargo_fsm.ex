defmodule Ucargo.Fsm do
  @moduledoc """
  Finite Machine State for Orders
  """
  use Fsm, initial_state: :new

  defstate new do         # opens the state scope
    defevent assign do           # defines event
      next_state(:approved)    # transition to next state
    end
  end

  defstate approved do
    defevent begin do
      next_state(:on_route)
    end
  end
end