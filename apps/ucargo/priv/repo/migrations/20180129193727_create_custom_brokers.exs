defmodule Ucargo.Repo.Migrations.CreateCustomBrokers do
  use Ecto.Migration

  def change do
    create table(:custom_brokers) do
      add :name, :string
    end
  end
end
