defmodule Ucargo.Repo.Migrations.PlaningBelongsToCustomBroker do
  use Ecto.Migration

  def change do
    alter table(:planings) do
      add :custom_broker_id, references(:custom_brokers, on_delete: :nothing)
    end
  end
end
