defmodule Ucargo.Repo.Migrations.CreateFavouriteDrivers do
  use Ecto.Migration

  def change do
    create table(:favourite_drivers) do
      add :driver_id, references(:drivers)
      add :custom_broker_id, references(:custom_brokers)
    end

    create unique_index(:favourite_drivers, [:driver_id, :custom_broker_id])
  end
end
