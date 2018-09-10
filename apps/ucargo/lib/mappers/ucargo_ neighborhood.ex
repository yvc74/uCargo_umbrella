defmodule Ucargo.Neighborhood do
  @moduledoc """
  Ecto User Mapper
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Ucargo.{Repo, Neighborhood}

  schema "neighborhoods" do
    field :name, :string
    timestamps()
    belongs_to :city, Ucargo.City
  end

  def changeset(%Neighborhood{} = neighborhood, attrs) do
    neighborhood
      |> cast(attrs, [:name, :city_id])
      |> validate_required([:name, :city_id])
      |> assoc_constraint(:city)
  end

end