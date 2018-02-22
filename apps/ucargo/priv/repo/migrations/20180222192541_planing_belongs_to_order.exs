defmodule Ucargo.Repo.Migrations.PlaningBelongsToOrder do
  use Ecto.Migration

  def change do
    alter table(:planings) do
      add :order_id, references(:orders, on_delete: :nothing)
    end
  end
end
