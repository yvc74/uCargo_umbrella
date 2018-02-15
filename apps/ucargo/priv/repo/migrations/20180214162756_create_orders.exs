defmodule Ucargo.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :favorite, :boolean
      add :score, :integer
      add :status, :string
      add :type, :integer
      add :deadline, :naive_datetime
      add :distance, :string
      add :merchandise_type, :string
      add :order_number, :integer
      add :transport, :string
      add :weight, :string 
      add :comments, :string           
      add :user_id, references(:drivers, on_delete: :nothing)
      timestamps()
    end
  end
end
