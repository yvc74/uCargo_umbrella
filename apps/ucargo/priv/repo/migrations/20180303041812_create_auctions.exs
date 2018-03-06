defmodule Ucargo.Repo.Migrations.CreateAuctions do
  use Ecto.Migration

  def change do
    create table(:auctions) do
      add :begin_date, :naive_datetime
      add :end_date, :naive_datetime
      add :ask_price, :decimal
      add :planning_id, references(:plannings)
    end
  end
end
