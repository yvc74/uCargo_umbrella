defmodule Ucargo.Order do
  @moduledoc """
  Ecto Order Mapper
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Ucargo.Order
  #alias Ucargo.Repo

  schema "orders" do
    field :favorite, :boolean
    field :score, :integer
    field :deadline, :naive_datetime
    belongs_to :driver, Ucargo.Driver
    timestamps()
  end

  def signup_changeset(%Order{} = order, attrs) do
    order
      |> cast(attrs, [:favorite, :score, :deadline, :user_id])
      |> validate_required([:deadline])
      |> assoc_constraint(:driver)
  end

end
