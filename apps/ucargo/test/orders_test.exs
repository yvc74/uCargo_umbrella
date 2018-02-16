defmodule Ucargo.OrderTest do
  @moduledoc """
    Test File for Orders data layer
  """
  use Ucargo.DataCase

  alias Ucargo.Driver

  test "Create Order" do
    changeset = Driver.signup_changeset(%Driver{},
    %{username: "johndoe", password: "12345678",
      email: "john@doe.com", picture: "picture", name: "John Doe"})
    assert changeset.valid? == true
  end
end
