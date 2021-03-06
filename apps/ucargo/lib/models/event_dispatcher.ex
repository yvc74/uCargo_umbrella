defmodule Ucargo.EventDispatcher do
  @moduledoc """
  Module for dispatch user events
  """
  alias Ucargo.Event
  alias Ucargo.Order
  alias Ucargo.Auction
  alias Ucargo.Bid
  alias Ucargo.AvailableOrder

  def dispatch(%{"id" => uuid, "name" => "Quote", "price" => price}, date, driver, available_order, fsm_mod) do
    order_fsm = fsm_mod.load(available_order.status)
    changeset = Event.changeset(%Event{}, %{uuid: uuid, name: "Quote", price: price, date: date})
    case changeset.valid? do
       true ->
        update_order_status({"Quote", "Quoted", order_fsm, changeset, available_order, price, driver.id}, fsm_mod)
       false ->
        {:error, changeset.errors}
    end
  end

  def dispatch(%{"id" => uuid, "name" => "Collect"}, date, _driver, available_order, fsm_mod) do
    order_fsm = fsm_mod.load(available_order.status)
    changeset = Event.changeset(%Event{}, %{uuid: uuid, name: "Collect", date: date})
    case changeset.valid? do
       true ->
        collect_status({"Collect", "Collected", order_fsm, changeset, available_order}, fsm_mod)
       false ->
        {:error, changeset.errors}
    end
  end

  def dispatch(%{"id" => uuid, "name" => "BeginCustom"}, date, _driver, available_order, fsm_mod) do
    order_fsm = fsm_mod.load(available_order.status)
    changeset = Event.changeset(%Event{}, %{uuid: uuid, name: "BeginCustom", date: date})
    case changeset.valid? do
       true ->
        begin_order_status({"BeginCustom", "OnRouteToCustom", order_fsm, changeset, available_order}, fsm_mod)
       false ->
        {:error, changeset.errors}
    end
  end

  def dispatch(%{"id" => uuid, "name" => "ReportGreen"}, date, _driver, available_order, fsm_mod) do
    order_fsm = fsm_mod.load(available_order.status)
    changeset = Event.changeset(%Event{}, %{uuid: uuid, name: "ReportGreen", date: date})
    case changeset.valid? do
       true ->
        report_green_status({"ReportGreen", "ReportedGreen", order_fsm, changeset, available_order}, fsm_mod)
       false ->
        {:error, changeset.errors}
    end
  end

  def dispatch(%{"id" => uuid, "name" => "ReportRed"}, date, _driver, available_order, fsm_mod) do
    order_fsm = fsm_mod.load(available_order.status)
    changeset = Event.changeset(%Event{}, %{uuid: uuid, name: "ReportRed", date: date})
    case changeset.valid? do
       true ->
        report_green_status({"ReportRed", "ReportedRed", order_fsm, changeset, available_order}, fsm_mod)
       false ->
        {:error, changeset.errors}
    end
  end

  def dispatch(%{"id" => uuid, "name" => "ReportLockExport", "picture" => lock_picture}, date, _driver, available_order, fsm_mod) do
    order_fsm = fsm_mod.load(available_order.status)
    changeset = Event.changeset(%Event{}, %{uuid: uuid, name: "ReportLock", date: date, picture: lock_picture})
    case changeset.valid? do
       true ->
        report_lock_status({"ReportLockExport", "ReportedLockExport", order_fsm, changeset, available_order, lock_picture}, fsm_mod)
       false ->
        {:error, changeset.errors}
    end
  end

  def dispatch(%{"id" => uuid, "name" => "ReportLock", "picture" => lock_picture}, date, _driver, available_order, fsm_mod) do
    order_fsm = fsm_mod.load(available_order.status)
    changeset = Event.changeset(%Event{}, %{uuid: uuid, name: "ReportLock", date: date, picture: lock_picture})
    case changeset.valid? do
       true ->
        report_lock_status({"ReportLock", "ReportedLock", order_fsm, changeset, available_order, lock_picture}, fsm_mod)
       false ->
        {:error, changeset.errors}
    end
  end

  def dispatch(%{"id" => uuid, "name" => "Store"}, date, _driver, available_order, fsm_mod) do
    order_fsm = fsm_mod.load(available_order.status)
    changeset = Event.changeset(%Event{}, %{uuid: uuid, name: "Store", date: date})
    case changeset.valid? do
       true ->
        store_merchandise_status({"Store", "Stored", order_fsm, changeset, available_order}, fsm_mod)
       false ->
        {:error, changeset.errors}
    end
  end

  def dispatch(%{"id" => uuid, "name" => "BeginRoute"}, date, _driver, available_order, fsm_mod) do
    order_fsm = fsm_mod.load(available_order.status)
    changeset = Event.changeset(%Event{}, %{uuid: uuid, name: "BeginRoute", date: date})
    case changeset.valid? do
       true ->
        begin_route_status({"BeginRoute", "OnRoute", order_fsm, changeset, available_order}, fsm_mod)
       false ->
        {:error, changeset.errors}
    end
  end

  def dispatch(%{"id" => uuid, "name" => "ReportLocation", "track" => %{"latitude" => lat, "longitude" => lon}}, date, _driver, available_order, fsm_mod) do
    order_fsm = fsm_mod.load(available_order.status)
    changeset = Event.changeset(%Event{}, %{uuid: uuid, name: "ReportLocation", date: date, latitude: lat, longitude: lon})
    case changeset.valid? do
       true ->
        report_tracking({"ReportLocation", "OnTracking", order_fsm, changeset, available_order}, fsm_mod)
       false ->
        {:error, changeset.errors}
    end
  end

  def dispatch(%{"id" => uuid, "name" => "ReportSign", "picture" => sign_picture}, date, _driver, available_order, fsm_mod) do
    order_fsm = fsm_mod.load(available_order.status)
    changeset = Event.changeset(%Event{}, %{uuid: uuid, name: "ReportSign", date: date, picture: sign_picture})
    case changeset.valid? do
      true ->
        report_sign({"ReportSign", "Signed", order_fsm, changeset, available_order}, fsm_mod)
      false ->
        {:error, changeset.errors}
    end
  end

  def dispatch(_, _, _order) do
    {:error, "Event with values sent is invalid"}
  end

  def collect_status({action, status, order_fsm, changeset, available_order}, fsm_mod) do
    case apply_next_stage(order_fsm, action, fsm_mod) do
      {:ok, _} ->
        chs = Order.update_changeset(available_order.order, %{status: status})
        av_order_changeset = AvailableOrder.update_changeset(available_order, %{status: status})
        AvailableOrder.update(av_order_changeset)
        Order.update(chs)
        Event.save(changeset)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def report_sign({action, status, order_fsm, changeset, available_order}, fsm_mod) do
    case apply_next_stage(order_fsm, action, fsm_mod) do
      {:ok, _} ->
        chs = Order.update_changeset(available_order.order, %{status: status})
        av_order_changeset = AvailableOrder.update_changeset(available_order, %{status: status})
        AvailableOrder.update(av_order_changeset)
        Order.update(chs)
        Event.save(changeset)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def report_tracking({action, status, order_fsm, changeset, available_order}, fsm_mod) do
    case apply_next_stage(order_fsm, action, fsm_mod) do
      {:ok, _} ->
        chs = Order.update_changeset(available_order.order, %{status: status})
        av_order_changeset = AvailableOrder.update_changeset(available_order, %{status: status})
        AvailableOrder.update(av_order_changeset)
        Order.update(chs)
        Event.save(changeset)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def report_lock_status({action, status, order_fsm, changeset, available_order, lock_picture}, fsm_mod) do
    case apply_next_stage(order_fsm, action, fsm_mod) do
      {:ok, _} ->
        chs = Order.update_changeset(available_order.order, %{status: status, lock_picture: lock_picture})
        av_order_changeset = AvailableOrder.update_changeset(available_order, %{status: status})
        AvailableOrder.update(av_order_changeset)
        Order.update(chs)
        Event.save(changeset)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def report_green_status({action, status, order_fsm, changeset, available_order}, fsm_mod) do
    case apply_next_stage(order_fsm, action, fsm_mod) do
      {:ok, _} ->
        chs = Order.update_changeset(available_order.order, %{status: status})
        av_order_changeset = AvailableOrder.update_changeset(available_order, %{status: status})
        AvailableOrder.update(av_order_changeset)
        Order.update(chs)
        Event.save(changeset)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def report_red_status({action, status, order_fsm, changeset, available_order}, fsm_mod) do
    case apply_next_stage(order_fsm, action, fsm_mod) do
      {:ok, _} ->
        chs = Order.update_changeset(available_order.order, %{status: status})
        av_order_changeset = AvailableOrder.update_changeset(available_order, %{status: status})
        AvailableOrder.update(av_order_changeset)
        Order.update(chs)
        Event.save(changeset)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def store_merchandise_status({action, status, order_fsm, changeset, available_order}, fsm_mod) do
    case apply_next_stage(order_fsm, action, fsm_mod) do
      {:ok, _} ->
        chs = Order.update_changeset(available_order.order, %{status: status})
        av_order_changeset = AvailableOrder.update_changeset(available_order, %{status: status})
        AvailableOrder.update(av_order_changeset)
        Order.update(chs)
        Event.save(changeset)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def begin_route_status({action, status, order_fsm, changeset, available_order}, fsm_mod) do
    case apply_next_stage(order_fsm, action, fsm_mod) do
      {:ok, _} ->
        chs = Order.update_changeset(available_order.order, %{status: status})
        av_order_changeset = AvailableOrder.update_changeset(available_order, %{status: status})
        AvailableOrder.update(av_order_changeset)
        Order.update(chs)
        Event.save(changeset)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def begin_order_status({action, status, order_fsm, changeset, available_order}, fsm_mod) do
    case apply_next_stage(order_fsm, action, fsm_mod) do
      {:ok, _} ->
        chs = Order.update_changeset(available_order.order, %{status: status})
        av_order_changeset = AvailableOrder.update_changeset(available_order, %{status: status})
        AvailableOrder.update(av_order_changeset)
        Order.update(chs)
        Event.save(changeset)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def update_order_status({action, status, order_fsm, changeset, available_order, price, driver_id}, fsm_mod) do
    case apply_next_stage(order_fsm, action, fsm_mod) do
      {:ok, _} ->
        chs = Order.update_changeset(available_order.order, %{status: status})
        bid_chgs = Bid.create_changeset(%Bid{}, %{price: price, winner: false, driver_id: driver_id})
        new_bid = Bid.save(bid_chgs)
        auction = available_order.order.planning.auction
        current_bids = auction.bids
        auction_chgs = Auction.update_changeset(auction, %{})
        auction_with_bids = Ecto.Changeset.put_assoc(auction_chgs, :bids, current_bids ++ [new_bid])
        Auction.update(auction_with_bids)
        av_order_changeset = AvailableOrder.update_changeset(available_order, %{bid_id: new_bid.id, status: "Quoted"})
        AvailableOrder.update(av_order_changeset)
        Order.update(chs)
        Event.save(changeset)
      {:error, reason} ->
        {:error, reason}
    end
  end

  def apply_next_stage(order_fsm, event_name, fsm_mod) do
    next_stage = fsm_mod.next_stage()[event_name]
    try do
      result = apply(fsm_mod, next_stage, [order_fsm])
      {:ok, result}
    rescue
      _err ->
        {:error, "Invalid state sent to a order"}
    end
  end

end