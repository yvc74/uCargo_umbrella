defmodule Ucargo.Repo.Migrations.CreateBids do
  use Ecto.Migration

  def change do
    create table(:bids) do
      add :price, :decimal
      add :auction_id, references(:auctions)
      add :winner, :boolean, default: false
    end
  end
end
