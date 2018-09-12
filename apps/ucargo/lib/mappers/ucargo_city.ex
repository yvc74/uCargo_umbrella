defmodule Ucargo.City do
  @moduledoc """
  Ecto User Mapper
  """

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Ucargo.{Repo, City}

  schema "cities" do
    field :name, :string
    timestamps()
    belongs_to :state, Ucargo.State
  end

  def changeset(%City{} = city, attrs) do
    city
      |> cast(attrs, [:name, :state_id])
      |> validate_required([:name, :state_id])
      |> assoc_constraint(:state)
  end

  def find(state_id) do
    query = from c in City,
            where: c.state_id == ^state_id,
            select: %{text: c.name, id: c.id}
    Repo.all(query)
  end

end