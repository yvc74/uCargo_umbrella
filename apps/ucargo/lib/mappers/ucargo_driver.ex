defmodule Ucargo.Driver do
  @moduledoc """
  Ecto Driver Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Ucargo.Driver
  alias Ucargo.Repo

  schema "drivers" do
    field :email, :string
    field :password, :string
    field :username, :string
    field :name, :string
    field :score, :integer
    field :phone, :string
    field :picture, :string
    field :password_conf, :string, virtual: true
    has_one :bid, Ucargo.Bid
    many_to_many :custom_brokers, Ucargo.CustomBroker, join_through: "favourite_drivers"
    many_to_many :orders, Ucargo.Order, join_through: "available_orders"
    many_to_many :assigned_orders, Ucargo.Driver,
                                  join_through: "assigned_orders",
                                  join_keys: [driver_id: :id, order_id: :id]
    timestamps()
  end

  def signup_changeset(%Driver{} = driver, attrs) do
    driver
      |> cast(attrs, [:username, :email, :password, :picture, :name, :phone, :score])
      |> validate_required([:username, :email, :password, :picture, :name, :phone])
      |> unique_constraint(:email)
      |> unique_constraint(:username)
  end

  def update_changeset(%Driver{} = driver, attrs) do
    driver
      |> cast(attrs, [:username, :email, :password, :picture, :name, :score, :phone])
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

  def fetch_all_mails do
    query = from d in Driver,
      select: d.email
    Repo.all(query)
  end
end
