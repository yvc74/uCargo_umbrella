defmodule Ucargo.Repo.Migrations.AvailableOrderBelongsToOrder do
  use Ecto.Migration

  def change do
    alter table(:available_orders) do
      add :order_id, references(:orders, on_delete: :nothing)
    end

  end
end
