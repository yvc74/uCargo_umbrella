defmodule Ucargo.Driver do
  @moduledoc """
  Ecto Driver Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Ucargo.Driver
  alias Ucargo.Repo

  schema "drivers" do
    field :email, :string
    field :password, :string
    field :username, :string
    field :password_conf, :string, virtual: true
    timestamps()
  end

  def signup_changeset(%Driver{} = driver, attrs) do
    driver
      |> cast(attrs, [:username, :email, :password])
      |> validate_required([:username, :email, :password])
      |> unique_constraint(:email)
      |> unique_constraint(:username)
  end

  def log_in(username, password) do
    with {:ok, driver} <- get_by_username(username) do
      if driver.password == password do
        {:ok, driver}
      else
        {:error, "Invalid credentials"}
      end
    else
      {:error, error} ->
        {:error, error}
    end
  end

  def create(changeset) do
    Repo.insert!(changeset)
  end

  def get_by_username(username) do
    case Repo.get_by(Driver, username: username) do
      nil ->
        {:error, "User not found"}
      driver ->
        {:ok, driver}
    end
  end

  def get_by_id(user_id) do
    case Repo.get_by(Driver, id: user_id) do
      nil ->
        {:error, "User not found"}
      driver ->
        {:ok, driver}
    end
  end
end