defmodule Ucargo.Repo.Migrations.FavoriteDriverBelongsToDriver do
  use Ecto.Migration

  def change do
    alter table(:favourite_drivers) do
      add :driver_id, references(:drivers, on_delete: :nothing)
    end

  end
end
