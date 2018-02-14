defmodule Ucargo.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :favorite, :boolean
      add :score, :integer
      add :deadline, :naive_datetime
      add :user_id, references(:users, on_delete: :nothing)
      timestamps()
    end
  end
end
