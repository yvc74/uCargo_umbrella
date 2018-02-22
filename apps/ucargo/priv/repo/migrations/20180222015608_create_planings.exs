defmodule Ucargo.Repo.Migrations.CreatePlanings do
  use Ecto.Migration

  def change do
    create table(:planings) do
      add :name, :string
    end
  end
end
