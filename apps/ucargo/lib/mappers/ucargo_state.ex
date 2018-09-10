defmodule Ucargo.State do
  @moduledoc """
  Ecto User Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Ucargo.{Repo, State, City}

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

end