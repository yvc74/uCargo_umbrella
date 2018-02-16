defmodule Ucargo.Mappers.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ucargo.Mappers.User


  schema "users" do
    field :email, :string
    field :password_digest, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password_digest])
    |> validate_required([:username, :email, :password_digest])
  end
end
