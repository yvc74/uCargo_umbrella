defmodule Ucargo.Repo.Migrations.Deliveries do
  use Ecto.Migration

  def change do
    create table(:deliveries) do
      add :latitude, :decimal, precision: 8, scale: 6
      add :longitude, :decimal, precision: 8, scale: 6
      add :name, :string
      add :address, :string
      add :schedule, :string
      add :order_id, references(:orders, on_delete: :nothing)
      timestamps()
    end
  end
end
