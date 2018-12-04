defmodule Kraken.Geocoding do
  @moduledoc """
  Module for geocoding address
  """
  require Logger

  def get_geocoding(adreess) do
    response = perform_geocoding_request(adreess)
    case response.status_code do
      200 ->
        body = Jason.decode!(response.body)
        {:ok, parse_result(body)}
      _ ->
        Logger.info("inspect #{response.body}")
        {:error, "Error in request from google geocoding"}
    end
  end

  defp parse_result(body) do
    %{"results" => [component|_]} = body
    %{"geometry" => %{"location" => %{"lat" => lat, "lng" => long}}} = component
    %{lat: lat, long: long}
  end

  defp perform_geocoding_request(address) do
    params = %{address: address,
               key: "AIzaSyDX-OBbccd9NqCr7fxvH7jxn7vwmMnNerI"}
    HTTPoison.get!(
      "https://maps.googleapis.com/maps/api/geocode/json",
      [],
      params: params
    )
  end
end