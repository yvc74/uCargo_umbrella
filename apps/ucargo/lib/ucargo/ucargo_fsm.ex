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
      next_state(:wait_for_custom_picking)
    end
  end

  defstate wait_for_custom_picking do
    defevent begin_custom do
      next_state(:on_route_to_custom)
    end
  end

  defstate on_route_to_custom do
    defevent report_green do
      next_state(:on_route)
    end

    defevent report_red do
      next_state(:pama)
    end
  end

  defstate on_route do
    defevent report_pama do
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
      "Approved" => :wait_for_custom_picking,
      "OnRouteToCustom" => :on_route_to_custom}
  end

  def next_stage do
    %{"Quote" => :bid,
      "Approve" => :approve,
      "BeginCustom" => :begin_custom,
      "ReportGreen" => :report_green}
  end
end