defmodule Ucargo.State do
  @moduledoc """
  Ecto User Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Ucargo.{Repo, State}

  schema "states" do
    field :name, :string
    has_many :cities, Ucargo.City
    timestamps()
  end

  @doc false
  def changeset(%State{} = state, attrs) do
    state
      |> cast(attrs, [:name])
      |> validate_required([:name])
  end

  def all do
    query = from s in State,
            order_by: s.name,
            select: {s.name, s.id}
    Repo.all(query)
  end

end