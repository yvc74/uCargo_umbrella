defmodule Ucargo.Repo.Migrations.CreateCustomCatalogs do
  use Ecto.Migration

  def change do
    create table(:custom_catalogs) do
      add :latitude, :decimal, precision: 9, scale: 6
      add :longitude, :decimal, precision: 9, scale: 6
      add :name, :string
      add :address, :string
      add :schedule, :string
      timestamps()
    end

  end
end
