defmodule Ucargo.Repo.Migrations.CreatePlanings do
  use Ecto.Migration

  def change do
    create table(:plannings) do
      add :name, :string
      add :custom_broker_id, references(:custom_brokers, on_delete: :nothing)
    end
  end
end
