defmodule Ucargo.Event do
  @moduledoc """
  Ecto User Mapper
  """
  use Ecto.Schema
  alias Ucargo.Event
  import Ecto.Changeset

  schema "events" do
    field :uuid, :string
    field :name, :string
    field :picture, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :date, :naive_datetime
    timestamps()
  end

  @doc false
  def changeset(%Event{} = user, attrs) do
    user
    |> cast(attrs, [:uuid, :name, :picture, :latitude, :longitude, :date])
    |> validate_required([:uuid, :name])
    |> unique_constraint(:uuid)
  end
end