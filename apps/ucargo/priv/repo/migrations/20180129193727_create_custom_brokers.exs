defmodule Ucargo.Repo.Migrations.CreateCustomBrokers do
  use Ecto.Migration

  def change do
    create table(:custom_brokers) do
      add :name, :string
      add :company, :string
      add :email, :string
      add :username, :string
      add :password, :string
    end
  end
end
