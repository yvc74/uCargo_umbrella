defmodule Ucargo.Repo.Migrations.CreateFavouriteDrivers do
  use Ecto.Migration

  def change do
    create table(:favourite_drivers) do
      add :name, :string
    end
  end
end
