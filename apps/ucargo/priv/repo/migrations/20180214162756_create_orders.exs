defmodule Ucargo.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :favourite, :boolean, default: false
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
      add :custom_light_picture, :string
      add :lock_picture, :string
      add :deliver_picture, :string
      add :invoice_xml, :text
      add :invoice_pdf, :bytea
      add :driver_id, references(:drivers, on_delete: :nothing)
      add :planning_id, references(:plannings)
      timestamps()
    end
  end
end
