defmodule Ucargo.Repo.Migrations.AssignedOrderBelongsToOrder do
  use Ecto.Migration

  def change do
    alter table(:assigned_orders) do
      add :order_id, references(:orders, on_delete: :nothing)
    end
  end
end
