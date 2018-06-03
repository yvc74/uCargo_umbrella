defmodule UcargoWeb.RoleControllerTest do
  use UcargoWeb.ConnCase

  alias Ucargo.{Role, Repo}

  setup do
    role_chs = Role.changeset(%Role{}, %{name: "admin", admin: true})
    role = Repo.insert! role_chs
    {:ok, role: role}
  end

  test "role", %{role: _role} do
    
  end

end
