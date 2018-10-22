defmodule Ucargo.Repo.Migrations.CreateDrivers do
  use Ecto.Migration

  def change do
    create table(:drivers) do
      add :username, :string
      add :name, :string
      add :email, :string
      add :password, :string
      add :picture, :string
      add :score, :integer, default: 5
      add :phone, :string
      add :rfc, :string
      add :address, :string
      timestamps()
    end

    create unique_index(:drivers, [:email])
  end
end
