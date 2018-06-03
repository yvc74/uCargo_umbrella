defmodule UcargoWeb.UserControllerTest do
  use UcargoWeb.ConnCase

  alias Ucargo.{User, Repo}

  setup do
    user_chs = User.changeset(%User{}, %{username: "username", email: "email@test.com", password_digest: "1234!"})
    user = Repo.insert! user_chs
    {:ok, user: user}
  end

  test "test user", %{user: _user} do
  end
end
