defmodule Ucargo.Repo.Migrations.AddRoleUserReference do
  use Ecto.Migration

  def change do
  	alter table(:users) do
      add :role_id, references(:users, on_delete: :nothing)
    end 
  end
end
