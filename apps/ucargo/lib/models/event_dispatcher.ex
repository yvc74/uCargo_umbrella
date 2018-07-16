defmodule Ucargo.EventDispatcher do
  @moduledoc """
  Module for dispatch user events
  """
  alias Ucargo.Event
  alias Ucargo.Fsm
  alias Ucargo.Order

  def dispatch(%{"id" => uuid, "name" => "Quote", "price" => price}, date, order) do
    order_fsm = Fsm.load(order.status)
    changeset = Event.changeset(%Event{}, %{uuid: uuid, name: "Quote", price: price, date: date})
    case changeset.valid? do
       true ->
        update_order_status("Quote", "Quoted", order_fsm, changeset, order)
       false ->
        {:error, changeset.errors}
    end
  end

  def dispatch(_, _, _order) do
    {:error, "Event with values sent is invalid"}
  end

  def update_order_status(action, status, order_fsm, changeset, order) do
    case apply_next_stage(order_fsm, action) do
      {:ok, _} ->
        chs = Order.update_changeset(order, %{status: status})
        IO.inspect order
        #Order.update(chs)
        #Event.save(changeset)
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