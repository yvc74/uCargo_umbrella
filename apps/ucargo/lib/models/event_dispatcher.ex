defmodule Ucargo.EventDispatcher do
  @moduledoc """
  Module for dispatch user events
  """
  alias Ucargo.Event
  alias Ucargo.Fsm
  alias Ucargo.Order
  alias Ucargo.Auction
  alias Ucargo.Bid
  alias Ucargo.AvailableOrder

  def dispatch(%{"id" => uuid, "name" => "Quote", "price" => price}, date, driver, available_order) do
    order_fsm = Fsm.load(available_order.status)
    changeset = Event.changeset(%Event{}, %{uuid: uuid, name: "Quote", price: price, date: date})
    case changeset.valid? do
       true ->
        update_order_status({"Quote", "Quoted", order_fsm, changeset, available_order, price, driver.id})
       false ->
        {:error, changeset.errors}
    end
  end

  def dispatch(_, _, _order) do
    {:error, "Event with values sent is invalid"}
  end

  def update_order_status({action, status, order_fsm, changeset, available_order, price, driver_id}) do
    case apply_next_stage(order_fsm, action) do
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

  def apply_next_stage(order_fsm, event_name) do
    next_stage = Ucargo.Fsm.next_stage()[event_name]
    try do
      result = apply(Ucargo.Fsm, next_stage, [order_fsm])
      {:ok, result}
    rescue
      _ ->
        {:error, "Invalid state sent to a order"}
    end
  end

end