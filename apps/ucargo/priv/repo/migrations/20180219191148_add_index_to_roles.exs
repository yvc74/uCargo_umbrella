defmodule Ucargo.Repo.Migrations.AddIndexToRoles do
  use Ecto.Migration

  def change do
  	create index(:users, [:role_id])
  end
end
