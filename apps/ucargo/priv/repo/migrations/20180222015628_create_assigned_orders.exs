defmodule Ucargo.Repo.Migrations.CreateAssignedOrders do
  use Ecto.Migration

  def change do
    create table(:assigned_orders) do
      add :driver_id, references(:drivers)
      add :order_id, references(:orders)
    end
    create unique_index(:assigned_orders, [:driver_id, :order_id])
  end
end
