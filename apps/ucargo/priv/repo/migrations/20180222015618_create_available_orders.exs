defmodule Ucargo.Repo.Migrations.CreateAvailableOrders do
  use Ecto.Migration

  def change do
    create table(:available_orders) do
      add :driver_id, references(:drivers)
      add :order_id, references(:orders)
    end
    create unique_index(:available_orders, [:driver_id, :order_id])    
  end
end
