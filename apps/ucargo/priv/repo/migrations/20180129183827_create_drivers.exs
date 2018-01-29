defmodule Ucargo.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:drivers) do
      add :username, :string
      add :name, :string
      add :email, :string
      add :password, :string
      timestamps()
    end

    create unique_index(:drivers, [:email])
  end
end
