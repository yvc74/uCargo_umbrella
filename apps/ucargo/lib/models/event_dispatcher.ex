defmodule Ucargo.EventDispatcher do
  @moduledoc """
  Module for dispatch user events
  """
  alias Ucargo.Event

  def dispatch(%{"id" => uuid, "name" => "Quote", "price" => price}, date, _order) do
    changeset = Event.changeset(%Event{}, %{uuid: uuid, name: "Quote", price: price, date: date})
    IO.inspect changeset
    case changeset.valid? do
       true ->
        Event.save(changeset)
       false ->
        {:error, changeset.errors}
    end
  end
end