defmodule Ucargo.TransportCatalog do
  @moduledoc """
  Ecto Transport Catalogs Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Ucargo.Repo
  alias Ucargo.TransportCatalog

  schema "transport_catalogs" do
    field :name, :string
    field :payload, :string
    field :cubic_capacity, :string
    field :length, :string
    field :width, :string
    field :height, :string    
    timestamps()
  end

  def create_changeset(%TransportCatalog{} = transportcatalog, attrs) do
    transportcatalog
      |> cast(attrs, [:name, :payload, :cubic_capacity, :length, :width, :height])
  end

  def fetch_all_transport_catalog do
    query = from d in TransportCatalog,
      select: d.name
    Repo.all(query)
  end
end