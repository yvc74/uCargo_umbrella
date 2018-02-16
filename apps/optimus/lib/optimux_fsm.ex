defmodule Optimus.BasicFsm do
  use Fsm, initial_state: :stopped

  defstate stopped do         # opens the state scope
    defevent run do           # defines event
      next_state(:running)    # transition to next state
    end
  end

  defstate running do
    defevent stop do
      next_state(:stopped)
    end
  end
end
