defmodule Ucargo.CommonParameters do
  @moduledoc "Common parameter declarations for phoenix swagger"

  alias PhoenixSwagger.Path.PathObject
  import PhoenixSwagger.Path

  def authorization(path = %PathObject{}) do
    path 
    |> parameter("X-Auth-Token", :header, :string, "Access token", required: true)
    |> parameter("X-Api-Key", :header, :string, "API key", default: "e70e918f-8035-48fc-a707-4507e1fd85c1", required: true)
  end

  def sorting(path = %PathObject{}) do
    path
    |> parameter(:sort_by, :query, :string, "The property to sort by")
    |> parameter(:sort_direction, :query, :string, "The sort direction", enum: [:asc, :desc], default: :asc)
  end
end