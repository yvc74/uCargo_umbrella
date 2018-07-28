defmodule Ucargo.Fsm do
  @moduledoc """
  Finite Machine State for Orders
  """
  use Fsm, initial_state: :new

  defstate new do         # opens the state scope
    defevent bid do           # defines event
      next_state(:driver_quoted)    # transition to next state
    end
  end

  defstate driver_quoted do
    defevent approve do
      next_state(:wait_for_start)
    end
  end

  defstate wait_for_start do
    defevent begin do
      next_state(:custom_hold)
    end
  end

  defstate custom_hold do
    defevent report_green do
      next_state(:on_route)
    end
  end

  def load(order_status) do
    state = states()[order_status]
    %Ucargo.Fsm{data: nil, state: state}
  end

  def states do
    %{"New" => :new,
      "Quoted" => :driver_quoted,
      "Approved" => :wait_for_start}
  end

  def next_stage do
    %{"Quote" => :bid,
      "Approve" => :approve,
      "Begin" => :begin}
  end
end