defmodule Ucargo.Repo.Migrations.Deliveries do
  use Ecto.Migration

  def change do
    create table(:deliveries) do
      add :latitude, :string
      add :longitude, :string
      add :name, :string
      add :address, :string
      add :schedule, :string
      add :order_id, references(:orders, on_delete: :nothing)
      timestamps()
    end
  end
end
