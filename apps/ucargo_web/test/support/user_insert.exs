defmodule OrderInsertHelper do
  alias Ucargo.{User, Role}
  alias Ucargo.Repo

  def create_user do

    role_params = %{name: "aduanal", admin: true}
    role = %Role{}
    role_chs = Role.create_changeset(role, role_params)

    Repo.insert!(role_chs)

    role_inserted = Repo.get_by(Role, name: "aduanal")

    user_params = %{username: "userTest", password_digest: "1234", email: "test@user.com",  role_id: role_inserted.id}
    user = %User{}    
    user_chs = User.create_changeset(user, user_params)      

    role_params = %{name: "aduanal", admin: true}
    role = %Role{}
    role_chs = Role.create_changeset(role, role_params)

    

    Repo.insert! user_chs
  end
end
