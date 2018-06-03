defmodule Ucargo.EventDispatcher do
  @moduledoc """
  Module for dispatch user events
  """
  alias Ucargo.Event

  def dispatch(%{"id" => uuid, "name" => name}, date, _order) do
    changeset = Event.changeset(%Event{}, %{uuid: uuid, name: name, date: date})
    case changeset.valid? do
       true ->
        Event.save(changeset)
       false ->
        {:error, changeset.errors}
    end
  end
end