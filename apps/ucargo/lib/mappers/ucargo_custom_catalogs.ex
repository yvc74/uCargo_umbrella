defmodule Ucargo.CustomCatalog do
  @moduledoc """
  Ecto Custom Catalogs Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Ucargo.Repo
  alias Ucargo.CustomCatalog

  schema "custom_catalogs" do
    field :name, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :address, :string
    field :schedule, :string
    timestamps()
  end

  def create_changeset(%CustomCatalog{} = customcatalog, attrs) do
    customcatalog
      |> cast(attrs, [:latitude, :longitude, :name, :address, :schedule])
      |> validate_required([:latitude, :longitude])
  end
    
  def fetch_all_custom_catalog do
    query = from d in CustomCatalog,
      select: d.name
    Repo.all(query)
  end

  def get_by_name(name) do
    case Repo.get_by(CustomCatalog, name: name) do
      nil ->
        {:error, "User not found"}
      custom_catalog ->
        {:ok, custom_catalog}
    end
  end
end
