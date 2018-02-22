defmodule Ucargo.Repo.Migrations.CreateAvailableOrders do
  use Ecto.Migration

  def change do
    create table(:available_orders) do
      add :name, :string
    end
  end
end
