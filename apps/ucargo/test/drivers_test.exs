defmodule Ucargo.DriverTest do
  @moduledoc """
    Test File for drivers data layer
  """
  use Ucargo.DataCase

  alias Ucargo.Driver

  test "Create Driver" do
    changeset = Driver.signup_changeset(%Driver{},
    %{username: "johndoe", password: "12345678", phone: "5534734763",
      email: "john@doe.com", picture: "picture", name: "John Doe"})
    assert changeset.valid? == true
  end
end
