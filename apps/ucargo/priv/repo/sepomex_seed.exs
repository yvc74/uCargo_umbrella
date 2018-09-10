alias Ucargo.{State, Repo, City, Neighborhood}



path = Application.app_dir(:kraken, "priv/sepomex_files/**")
files = Path.wildcard(path)

Enum.each(files, fn(file) ->
  file_name = Path.basename(file)
  state_name = String.replace(file_name, ".csv", "")
  container = Kraken.SepomexParser.parse_file(file_name)
  keys = Agent.get(container, &Map.keys(&1))

  state_change_set = State.changeset(%State{}, %{name: state_name})
  state = Repo.insert!(state_change_set)
  Enum.each(keys, fn(city) ->
    city_changeset = City.changeset(%City{}, %{name: city, state_id: state.id})
    current_city = Repo.insert!(city_changeset)
    neighborhoods = Agent.get(container, &Map.get(&1, city))
    Enum.each(neighborhoods, fn(neighborhood) ->
      neighborhood_changeset = Neighborhood.changeset(%Neighborhood{}, %{name: neighborhood, city_id: current_city.id})
      Repo.insert!(neighborhood_changeset)
    end)
  end)
end)





