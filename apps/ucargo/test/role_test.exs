defmodule Ucargo.RoleTest do
  @moduledoc """
    Test File for roles data layer
  """
  use Ucargo.DataCase

  alias Ucargo.Role

  test "Create Role" do

    changeset = Role.changeset(%Role{}, 
      %{name: "admin", 
        admin: true})
    assert changeset.valid? == true
  end
end