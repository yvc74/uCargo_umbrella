defmodule Ucargo.Repo.Migrations.AddNeighborhoods do
  use Ecto.Migration

  def change do
    create table(:neighborhoods) do
      add :name, :string
      timestamps()
      add :city_id, references(:cities, on_delete: :nothing)
    end
  end
end
