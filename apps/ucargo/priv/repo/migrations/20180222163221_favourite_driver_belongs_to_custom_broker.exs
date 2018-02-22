defmodule Ucargo.Repo.Migrations.FavouriteDriverBelongsToCustomBroker do
  use Ecto.Migration

  def change do
    alter table(:favourite_drivers) do
      add (:custom_broker_id), references(:favourite_drivers, on_delete: :nothing)
    end

  end
end
