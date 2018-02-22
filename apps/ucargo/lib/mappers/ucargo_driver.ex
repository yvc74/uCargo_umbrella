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
    field :name, :string
    field :picture, :string
    field :password_conf, :string, virtual: true
    has_many :orders, Ucargo.Order
    #has_many :favourite_drivers, Ucargo.FavouriteDrivers
    #has_many :assigned_orders, Ucargo.AssignedOrder
    #has_many :available_order, Ucargo.AvailableOrder
    many_to_many :custom_brokers, Ucargo.CustomBroker, join_through: "favourite_drivers"
    timestamps()
  end

  def signup_changeset(%Driver{} = driver, attrs) do
    driver
      |> cast(attrs, [:username, :email, :password, :picture, :name])
      |> validate_required([:username, :email, :password, :picture, :name])
      |> unique_constraint(:email)
      |> unique_constraint(:username)
  end

  def update_changeset(%Driver{} = driver, attrs) do
    driver
      |> cast(attrs, [:username, :email, :password, :picture, :name])
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

  def update(changeset) do
    Repo.update!(changeset)
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
