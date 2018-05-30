defmodule Ucargo.Repo.Migrations.CreateTransportCatalogs do
  use Ecto.Migration

  def change do
    create table(:transport_catalogs) do
      add :name, :string
      add :payload, :string
      add :cubic_capacity, :string
      add :length, :string
      add :width, :string
      add :height, :string
      timestamps()
    end
  end
end
