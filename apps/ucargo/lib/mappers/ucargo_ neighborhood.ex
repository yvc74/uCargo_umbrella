defmodule Ucargo.Neighborhood do
  @moduledoc """
  Ecto User Mapper
  """

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
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

  def find(city_id) do
    query = from n in Neighborhood,
            where: n.city_id == ^city_id,
            select: %{text: n.name, id: n.id}
    Repo.all(query)
  end

end