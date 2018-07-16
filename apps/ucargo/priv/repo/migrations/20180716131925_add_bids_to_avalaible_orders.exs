defmodule Ucargo.Repo.Migrations.AddBidsToAvalaibleOrders do
  use Ecto.Migration

  def change do
    alter table(:available_orders) do
      add :bid_id, references(:bids)
      add :status, :string, default: "New"
    end
  end
end
