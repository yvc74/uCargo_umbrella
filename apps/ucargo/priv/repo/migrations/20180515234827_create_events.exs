defmodule Ucargo.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :uuid, :string
      add :name, :string
      add :picture, :string
      add :latitude, :decimal, precision: 9, scale: 6
      add :longitude, :decimal, precision: 9, scale: 6
      add :date, :naive_datetime
      timestamps()
    end

    create unique_index(:events, [:uuid])
  end
end
