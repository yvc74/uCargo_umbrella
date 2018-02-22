defmodule Ucargo.Repo.Migrations.AvailableOrderBelongsToDriver do
  use Ecto.Migration

  def change do
    alter table(:available_orders) do
      add :driver_id, references(:drivers, on_delete: :nothing)
    end
  end
end
