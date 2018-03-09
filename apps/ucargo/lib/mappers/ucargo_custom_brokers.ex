defmodule Ucargo.CustomBroker do
  @moduledoc """
  Ecto CustomBrokers Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Ucargo.Repo
  alias Ucargo.CustomBroker

  schema "custom_brokers" do
    field :name, :string
    field :company, :string
    field :username, :string
    field :password, :string
    has_many :plannings, Ucargo.Planning
    many_to_many :drivers, Ucargo.Driver, join_through: "favourite_drivers"
  end

  def create_changeset(%CustomBroker{} = custombroker, attrs) do
    custombroker
      |> cast(attrs, [:username, :password])
  end

  def login_changeset(%CustomBroker{} = broker, params) do
    broker
      |> cast(params, [:username, :password])
      |> validate_user
      |> validate_password
  end

  def update_changeset(%CustomBroker{} = custombroker, attrs) do
    custombroker
      |> cast(attrs, [:username, :password])
  end

  defp validate_user(changeset) do
    username = get_field(changeset, :username)
    case exists?(username) do
      false ->
        add_error(changeset, :not_found, "User name #{username} not found")
      _ ->
        changeset
    end
  end

  def validate_password(changeset) do
    if changeset.valid? do
      input_pwd = get_field(changeset, :password)
      user_name = get_field(changeset, :username)
      case get_password(user_name) == input_pwd do
        true ->
          changeset
        false ->
          add_error(changeset, :wrong_pin, "User name or pin incorrect")
      end
    else
      changeset
    end
  end

  def get_by_user_name(username) do
    case Repo.get_by(CustomBroker, username: username) do
      nil ->
        {:error, "Broker not found"}
      broker ->
        {:ok, broker}
    end
  end

  def get_by_id(broker_id) do
    case Repo.get_by(CustomBroker, id: broker_id) do
      nil ->
        {:error, "Broker not found"}
      broker ->
        {:ok, broker}
    end
  end

  defp get_password(username) do
    query = from c in CustomBroker,
          where: c.username == ^username,
          select: c.password
    Repo.one(query)
  end

  defp exists?(username) do
    query = from c in CustomBroker,
          where: c.username == ^username,
          select: count("*")
    case Repo.one(query) do
      0 ->
        false
      _ ->
        true
    end
  end
end
