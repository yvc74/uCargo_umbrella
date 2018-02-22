defmodule Ucargo.Repo.Migrations.AssignedOrderBelongsToDriver do
  use Ecto.Migration

  def change do
    alter table(:assigned_orders) do
      add :driver_id, references(:drivers, on_delete: :nothing)
    end
  end
end
