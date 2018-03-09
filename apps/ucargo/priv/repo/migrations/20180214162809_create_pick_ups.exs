defmodule Ucargo.Repo.Migrations.CreatePickUps do
  use Ecto.Migration

  def change do
    create table(:pick_ups) do
      add :latitude, :decimal, precision: 9, scale: 6
      add :longitude, :decimal, precision: 9, scale: 6
      add :name, :string
      add :address, :string
      add :schedule, :string
      add :responsible, :string
      add :date, :date
      add :order_id, references(:orders, on_delete: :nothing)
      timestamps()
    end

  end
end
