defmodule Ucargo.UserTest do
  @moduledoc """
    Test File for drivers data layer
  """
  use Ucargo.DataCase

  alias Ucargo.User

  test "Create User" do

    changeset = User.changeset(%User{}, 
      %{username: "username", 
        email: "email@test.com", 
        password_digest: "1234!"})    
    assert changeset.valid? == true
  end
end