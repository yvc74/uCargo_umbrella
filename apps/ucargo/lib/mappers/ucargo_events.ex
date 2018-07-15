defmodule Ucargo.Event do
  @moduledoc """
  Ecto User Mapper
  """
  use Ecto.Schema
  alias Ucargo.Event
  alias Ucargo.Repo
  import Ecto.Changeset
  import Ecto.Query

  schema "events" do
    field :uuid, :string
    field :name, :string
    field :picture, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :price, :decimal
    field :date, :naive_datetime
    timestamps()
  end

  @doc false
  def changeset(%Event{} = user, attrs) do
    user
      |> cast(attrs, [:uuid, :name, :picture, :latitude, :price, :longitude, :date])
      |> validate_required([:uuid, :name])
      |> validate_uuid
      |> unique_constraint(:uuid)
  end

  def validate_uuid(changeset) do
    uuid = get_field(changeset, :uuid)
    case Event.get_event(uuid) do
      nil ->
        changeset
      _ ->
        add_error(changeset, :found, "Event with uuid: #{uuid} has already been taken")
    end
  end

  def save(changeset) do
    Repo.insert(changeset)
  end

  def get_event(event_uuid) do
    query = from e in Ucargo.Event,
          where: e.uuid == ^event_uuid,
          select: e.id
    Repo.one(query)
  end
end