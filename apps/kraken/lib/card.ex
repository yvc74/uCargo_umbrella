defmodule Kraken.Card do
  @moduledoc """
  Module for made charges to a credit card
  """
  require Logger

  def charge(location, name, key) do
    response = perform_search_request(location, name, key)
    case HTTPotion.Response.success?(response) do
      true ->
        response.body
      false ->
        Logger.info("Error Fetching places from Google for #{name}")
        {:error, "Error from google places"}
    end
  end

  defp perform_search_request(location, term, key) do
    headers = ["Authorization": "Bearer " <> key]
    params = %{term: term,
               latitude: location.latitude,
               longitude: location.longitude,
               radius: UnitsConverter.milles_to_meters(location.distance)}
    HTTPotion.get(
      "",
      query: params,
      headers: headers,
      timeout: 20_000
    )
  end
end
