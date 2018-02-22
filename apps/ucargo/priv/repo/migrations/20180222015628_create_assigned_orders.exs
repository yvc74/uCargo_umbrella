defmodule Ucargo.Repo.Migrations.CreateAssignedOrders do
  use Ecto.Migration

  def change do
    create table(:assigned_orders) do
      add :name, :string
    end
  end
end
