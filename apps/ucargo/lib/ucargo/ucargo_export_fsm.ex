defmodule Ucargo.ExportFsm do
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
      next_state(:wait_for_collect_merchandise)
    end
  end

  defstate wait_for_collect_merchandise do
    defevent collect do
      next_state(:take_picture)
    end
  end

  defstate take_picture do
    defevent report_lock_picture do
      next_state(:wait_for_custom_picking)
    end
  end

  defstate wait_for_custom_picking do
    defevent begin_custom do
      next_state(:on_route)
    end
  end

  defstate on_route_to_storage do
    defevent store_merchandise do
      next_state(:begin_route)
    end
  end

  defstate begin_delivery_route do
    defevent start_route do
      next_state(:on_route)
    end
  end

  defstate on_route do
    defevent report_location do
      next_state(:on_route)
    end

    defevent report_green do
      next_state(:wait_for_signing)
    end
  end

  defstate wait_for_signing do
    defevent report_sign do
      next_state(:signed)
    end
  end

  defstate signed do
    defevent finish do
      next_state(:finish)
    end
  end

  def load(order_status) do
    state = states()[order_status]
    %Ucargo.ExportFsm{data: nil, state: state}
  end

  #Stages translated from databases, value indicates
  def states do
    %{"New" => :new,
      "Quoted" => :driver_quoted,
      "Approved" => :wait_for_collect_merchandise, #**
      "Collected" => :take_picture,
      "ReportedLock" => :wait_for_custom_picking,
      "OnRouteToCustom" => :on_route,
      "OnRoute" => :on_route,
      "OnTracking" => :on_route,
      "ReportedGreen" => :wait_for_signing,
      "ReportedSign" => :on_route,
      "Signed" => :finish}
  end

  #Stages send in payload, this events are translated to a fsm event def event
  def next_stage do
    %{"Quote" => :bid,
      "Approve" => :approve, #**
      "Collect" => :collect,
      "BeginCustom" => :begin_custom,
      "ReportGreen" => :report_green,
      "ReportLock" => :report_lock_picture,
      "Store" => :store_merchandise,
      "BeginRoute" => :start_route,
      "ReportLocation" => :report_location,
      "ReportLockExport" => :report_export_lock_picture,
      "ReportSign" => :report_sign
    }
  end
end