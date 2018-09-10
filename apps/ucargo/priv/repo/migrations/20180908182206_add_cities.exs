defmodule Ucargo.Repo.Migrations.AddCities do
  use Ecto.Migration

  def change do
    create table(:cities) do
      add :name, :string
      timestamps()
      add :state_id, references(:states, on_delete: :nothing)
    end
  end
end
